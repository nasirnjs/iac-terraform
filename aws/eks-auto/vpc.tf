resource "aws_vpc" "ym_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ym-vpc"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.ym_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ym-private-1a"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.ym_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "ym-private-1b"
  }
}
