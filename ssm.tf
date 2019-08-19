resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "データベースの接続ユーザ名"
}

# dbのパスワードはTerraform ではダミー値を設定して、あとで AWS CLI で更新する
# aws ssm put-parameter --name '/db/password' --type SecureString --value 'ModifiedStrongPassword!' --overwrite
resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  value       = "uninitialized"
  type        = "SecureString"
  description = "データベースのパスワード"

  lifecycle {
    ignore_changes = [value]
  }
}
