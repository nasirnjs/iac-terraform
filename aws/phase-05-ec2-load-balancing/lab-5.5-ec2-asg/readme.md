# Lab 5.5 — EC2 Auto Scaling Group behind ALB with HTTPS (ACM + Route 53)

Provision an internet-facing Application Load Balancer that terminates TLS and forwards traffic to an Auto Scaling Group of Nginx EC2 instances in private subnets. The ACM certificate is DNS-validated through Route 53 and the apex/`www` records are aliased to the ALB.

## Architecture

```
        Route 53 (A ALIAS)
                │
                ▼
   ┌────────────────────────┐
   │  ALB (public subnets)  │  :80 → 301 → :443 (HTTPS, ACM cert)
   └───────────┬────────────┘
               │ forward
               ▼
   ┌────────────────────────┐
   │  Target Group (web-tg) │  HTTP :80, health check GET /
   └───────────┬────────────┘
               │ register/deregister (elbv2 traffic source)
               ▼
   ┌────────────────────────┐
   │  Auto Scaling Group    │  min=2, max=4, desired=2, ELB health
   │  (private subnets)     │  target-tracking on CPU = 60%
   └───────────┬────────────┘
               │ instances launched from
               ▼
   ┌────────────────────────┐
   │  Launch Template       │  AMI, instance type, SG, user_data, EBS
   └────────────────────────┘
```


## How the pieces fit together

### 1. Launch Template (`4-asg.tf`)
The autoscaling module creates a versioned launch template that is the blueprint for every instance the ASG launches:

- `image_id`, `instance_type`, `key_name` — base instance shape
- `security_groups` — attaches the `web_service_sg` (only accepts :80 from the ALB SG)
- `user_data` — bootstraps Nginx on first boot
- `block_device_mappings` — gp3 root volume, encrypted, sized via `root_disk_size`
- `update_default_version = true` — every change publishes a new default version so the ASG picks it up

### 2. Auto Scaling Group (`4-asg.tf`)
- `vpc_zone_identifier = module.vpc.private_subnets` — instances spread across the 3 private subnets
- `health_check_type = "ELB"` — ASG uses target-group health (not just EC2 status checks); a failing target gets terminated and replaced
- `health_check_grace_period = 300` — gives `user_data` time to install/start Nginx before health checks count
- `instance_refresh` — rolling replacement on launch-template changes, keeping ≥50% healthy
- `scaling_policies.cpu-target-tracking` — target-tracking policy on `ASGAverageCPUUtilization = 60`; ASG adds/removes instances within `[min_size, max_size]` to hold the target

### 3. Target Group (`5-alb.tf`)
- Defined inside the ALB module as `web-tg` (HTTP :80, `target_type = "instance"`)
- `create_attachment = false` — we do **not** statically attach instances; the ASG owns membership
- Health check: `GET /` every 30s, 2 consecutive 200s to mark healthy, 2 failures to mark unhealthy

### 4. ASG ↔ Target Group binding (`4-asg.tf`)
```hcl
traffic_source_attachments = {
  web = {
    traffic_source_identifier = module.alb.target_groups["web-tg"].arn
    traffic_source_type       = "elbv2"
  }
}
```
This is the wire between ASG and ALB. When the ASG launches an instance it auto-registers it in `web-tg`; when it terminates one it deregisters and waits for connection draining. No manual `aws_lb_target_group_attachment` is needed.

### 5. ALB listeners (`5-alb.tf`)
- **`http_redirect`** — port 80 returns `HTTP 301` to `https://...:443`
- **`https`** — port 443, TLS policy `ELBSecurityPolicy-TLS13-1-2-2021-06`, `certificate_arn` from ACM, default action forwards to `web-tg`
- **Listener rule `www_to_apex`** — requests with `Host: www.<domain>` are 301-redirected to the apex domain, preserving path and query

### 6. ACM certificate (`6-acm.tf`)
- `create_acm_certificate = true` (default) — module requests a public cert for `domain_name` with `subject_alternative_names`
- `validation_method = "DNS"` — ACM emits CNAME validation records into the Route 53 zone resolved by `data.aws_route53_zone.this`
- `wait_for_validation = true` — apply blocks until the cert is `ISSUED`, so the HTTPS listener can attach it
- To reuse an existing cert, set `create_acm_certificate = false` and pass `acm_certificate_arn`

### 7. Route 53 records (`7-route53.tf`)
- `data.aws_route53_zone.this` looks up the existing public hosted zone (`route53_zone_name`)
- `aws_route53_record.alb_alias` creates an **A-ALIAS** for the apex and every SAN, pointing to `module.alb.dns_name` / `module.alb.zone_id`
- `evaluate_target_health = true` — Route 53 stops returning the alias if the ALB is unhealthy

### Request flow
1. Client resolves `nasirtechtalks.com` → Route 53 alias → ALB IPs
2. ALB :443 terminates TLS using the ACM cert
3. ALB forwards to `web-tg`; target group routes to a healthy ASG instance over HTTP :80
4. Instance security group permits :80 only from the ALB SG
5. ASG replaces any instance the target group reports unhealthy


## References

- [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [terraform-aws-modules/autoscaling/aws](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest)
- [terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest)
- [terraform-aws-modules/acm/aws](https://registry.terraform.io/modules/terraform-aws-modules/acm/aws/latest)
- [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
