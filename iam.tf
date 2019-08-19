# ECS タスク実行 IAM ロール
## awsが用意しているecsタスク実行用のポリシー
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

## 独自のポリシー定義
data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  # 上記のecsタスク実行ポリシーを継承し、SSMパラメータストアのgetのポリシーも追加。
  # SSM パラメータストアの値(dbの環境変数)を、ECS の Docker コンテナ内で環境変数として参照するため追加。
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

## 作成した独自ポリシーをアタッチしたロールの作成
module "ecs_task_execution_role" {
  source     = "./modules/iam_role"
  name       = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}
# ECS タスク実行 IAM ロール ここまで
