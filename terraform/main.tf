#edit ~/.bashrc for environment variables

resource "aws_key_pair" "my_key_pair" {
  key_name   = "${terraform.workspace}_my_key_pair"
  public_key = file("/root/.ssh/id_rsa.pub")
}
