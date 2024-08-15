
###########################################################
# Define the WAF(Web Application Firewall) Web ACL
###########################################################

locals {
  web_acl_name = "${var.tags.Project}-web-acl-${var.tags.Env}"
  rule_name    = "rate-limit-rule-${var.tags.Env}"
}

resource "aws_wafv2_web_acl" "web_acl" {
  name        = local.web_acl_name
  scope       = "REGIONAL"
  description = "Web ACL with rate limiting for ALB"
  default_action {
    allow {}
  }

  rule {
    name     = local.rule_name
    priority = 1
    action {
      block {
        custom_response {
          response_code = 403
          response_header {
            name  = "WHAT-THE-HELL"
            value = "You are temporarily blocked"
          }
        }
      }
    }

    statement {
      rate_based_statement {
        limit                 = var.rate_limit
        evaluation_window_sec = var.evaluation_window_sec
        aggregate_key_type    = "IP"

        scope_down_statement {
          byte_match_statement {
            search_string = "/"
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 1
              type     = "NONE"
            }
            positional_constraint = "STARTS_WITH"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = local.rule_name
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.web_acl_name
    sampled_requests_enabled   = true
  }
}

# Attach the Web ACL to an existing ALB
resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}