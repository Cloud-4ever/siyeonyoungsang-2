resource "aws_s3_bucket" "static" {
  bucket = "var.name-prefix-static-assets-11fe0d"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-static-assets"
  })
}

resource "aws_s3_bucket" "logs" {
  bucket = "var.name-prefix-logs-11fe0d"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-logs"
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static" {
  bucket = aws_s3_bucket.static.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "static" {
  bucket                  = aws_s3_bucket.static.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group-11fe0d"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  identifier             = "${var.name_prefix}-db-11fe0d"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  storage_encrypted      = true
  kms_key_id             = var.kms_key_arn
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db"
  })
}

resource "aws_dynamodb_table" "reviews" {
  name         = "${var.name_prefix}-reviews-11fe0d"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "review_id"

  attribute {
    name = "review_id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-reviews"
  })
}
