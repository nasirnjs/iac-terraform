## What Are Built-in Functions?

Terraform built-in functions are reusable operations that help you transform, combine, validate, and manipulate data within your configuration.


## Terraform Functions by Type

| Type        | Functions                                    | What they do                             |
| ----------- | -------------------------------------------- | ---------------------------------------- |
| 🔤 String   | `upper`, `lower`, `join`, `split`, `replace` | Work with text (format, clean, combine)  |
| 📦 List     | `length`, `contains`                         | Work with arrays (count, check values)   |
| 🗺️ Map     | `lookup`, `merge`                            | Work with key-value data (configs, tags) |
| 🔐 Encoding | `jsonencode`                                 | Convert data into JSON format            |

## Few Example


**upper() Functions Example**
- upper("dev") → make text CAPITAL  Output: DEV

**join() Functions Example**
- join("-", ["web", "server", "01"]) → combine words Output: web-server-01

**length() Function Example**
- length(["a", "b", "c"]) → counts items Output: 3

## Example 1: Basic Single Instance

```yaml
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = "t2.micro"

  tags = {
    Name = join("-", ["myapp", "web", "dev"])  # "myapp-web-dev"
    Env  = upper("dev")                        # "DEV"
  }
}
```

## Example 2: Multiple Instances with Numbers

```yaml
resource "aws_instance" "web" {
  count = 2
  ami   = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = format("web-server-%02d", count.index + 1)  # "web-server-01", "web-server-02"
  }
}
```