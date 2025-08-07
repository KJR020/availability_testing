resource "aws_iam_role" "fis_execution" {
  name = "${var.project_name}-${var.environment}-fis-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "fis.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "fis_execution" {
  name = "${var.project_name}-${var.environment}-fis-execution-policy"
  role = aws_iam_role.fis_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:StopTask",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:DescribeServices",
          "ecs:DescribeClusters",
          "ec2:DescribeInstances",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "fis" {
  name              = "/aws/fis/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-fis-logs"
  })
}

resource "aws_fis_experiment_template" "stop_ecs_tasks" {
  description = var.experiment_description
  role_arn    = aws_iam_role.fis_execution.arn

  action {
    name        = "StopTasks"
    action_id   = "aws:ecs:stop-task"
    description = var.action_description

    parameter {
      key   = "clusterIdentifier"
      value = var.ecs_cluster_arn
    }

    parameter {
      key   = "serviceIdentifier"
      value = var.ecs_service_name
    }

    target {
      key   = "Tasks"
      value = "ecs-tasks"
    }
  }

  target {
    name           = "ecs-tasks"
    resource_type  = "aws:ecs:task"
    selection_mode = "PERCENT(${var.task_stop_percentage})"

    resource_arns = []

    resource_tag {
      key   = "aws:ecs:service-name"
      value = var.ecs_service_name
    }

    resource_tag {
      key   = "aws:ecs:cluster-name"
      value = var.ecs_cluster_name
    }

    # AZ指定がある場合のみ、AZフィルターを追加
    dynamic "filter" {
      for_each = length(var.target_availability_zones) > 0 ? [1] : []
      content {
        path   = "AvailabilityZone"
        values = var.target_availability_zones
      }
    }
  }

  stop_condition {
    source = "none"
  }

  log_configuration {
    log_schema_version = 1
    cloudwatch_logs_configuration {
      log_group_arn = "${aws_cloudwatch_log_group.fis.arn}:*"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-stop-tasks-experiment"
  })
}
