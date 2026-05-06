# Lab 5.3 — AWS Network Load Balancer (NLB)

Provision an internet-facing **Network Load Balancer** in front of EC2 instances running Nginx in private subnets.

## Why NLB (vs ALB)?

NLB operates at **Layer 4 (TCP/UDP/TLS)** — ALB operates at Layer 7 (HTTP/HTTPS). Reach for an NLB when you need:

| Use case                                  | Why NLB fits                                                                 |
| ----------------------------------------- | ---------------------------------------------------------------------------- |
| **Non-HTTP protocols** (TCP, UDP, TLS)    | ALB only speaks HTTP/HTTPS; NLB handles raw TCP/UDP (databases, MQTT, DNS, SMTP, RDP, game servers). |
| **Ultra-low latency** (~100µs)            | No L7 parsing — packets are forwarded at the transport layer.                |
| **Static IPs / Elastic IP per AZ**        | NLB exposes a fixed IP per AZ; clients/firewalls can allowlist these. ALB only gives a DNS name with rotating IPs. |
| **Extreme throughput** (millions of RPS)  | Scales to handle sudden, volatile traffic without pre-warming.               |
| **Source IP preservation**                | Backend instances see the real client IP (no `X-Forwarded-For` needed).      |
| **PrivateLink / VPC endpoint services**   | Only NLBs can sit behind a VPC Endpoint Service.                             |
| **Long-lived TCP connections**            | IoT, financial trading feeds, gaming, real-time streaming, VoIP.             |
| **TLS passthrough**                       | Terminate TLS on the instance (compliance / certificate pinning) instead of on the LB. |

For typical HTTP web apps with path/host routing, WAF, cookies, or redirects → use **ALB** (Lab 5.2). For TCP/UDP workloads, static IPs, or PrivateLink → use **NLB** (this lab).


## File layout

| File               | Purpose                                          |
| ------------------ | ------------------------------------------------ |
| `0-provider.tf`    | AWS provider, region                             |
| `1-variables.tf`   | Input variable declarations                      |
| `terraform.tfvars` | Input values                                     |
| `2-vpc.tf`         | VPC + subnets + NAT (terraform-aws-modules/vpc)  |
| `3-sg.tf`          | NLB and web instance security groups             |
| `4-ec2.tf`         | Web EC2 instances + target group attachments     |
| `5-nlb.tf`         | Network Load Balancer + listener + TG            |
| `6-outputs.tf`     | NLB DNS, app URL, instance IDs/IPs               |


## Notes & gotchas

- **Cross-zone LB is OFF by default on NLB** — enabled here. Disabling saves inter-AZ transfer cost but can cause uneven load if instance counts differ per AZ.
- **NLB security groups are opt-in at create time only** — you cannot add an SG to an existing SG-less NLB.
- **Health-check protocol:** NLB target groups accept `TCP`, `HTTP`, or `HTTPS` health checks. HTTP gives richer signal than a TCP handshake.
- **Source IP preservation** means the backend SG must allow traffic from real client IPs (here we restrict via the NLB SG, which works because client→NLB→target traffic still carries the NLB SG context when an SG is attached to the NLB).
- For UDP or TCP_UDP listeners, switch the listener and target group `protocol` accordingly.

## References

- [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest) (also provisions NLBs via `load_balancer_type = "network"`)
- [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
- [AWS — NLB vs ALB comparison](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/introduction.html)
