
###########################################################
# Define the IAM Role
###########################################################

locals {
  iam_role_name_backend  = "${var.tags.Project}-backend-role-${var.tags.Env}"
  iam_role_name_frontend = "${var.tags.Project}-frontend-role-${var.tags.Env}"
}

resource "aws_iam_role" "backend_iam_role" {
  name = local.iam_role_name_backend
  tags = merge({ Name = local.iam_role_name_backend }, var.tags)
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }]
    }
  )
}

resource "aws_iam_role" "frontend_iam_role" {

  name = local.iam_role_name_frontend
  tags = merge({ Name = local.iam_role_name_frontend }, var.tags)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ecr-access-policy"
  description = "Policy to allow EC2 to pull from ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "logs:*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "S3 access policy for EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:ListAllMyBuckets"
        ],
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy_to_backend" {
  role       = aws_iam_role.backend_iam_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_backend" {
  role       = aws_iam_role.backend_iam_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy_to_frontend" {
  role       = aws_iam_role.frontend_iam_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_instance_profile" "backend_instance_profile" {
  name = "ip-backend-${var.tags.Env}"
  role = aws_iam_role.backend_iam_role.name
}

resource "aws_iam_instance_profile" "frontend_instance_profile" {
  name = "ip-frontend-${var.tags.Env}"
  role = aws_iam_role.frontend_iam_role.name
}

