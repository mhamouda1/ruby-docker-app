resource "null_resource" "test2" {
  provisioner "local-exec" {
    working_dir = "../"
    command = <<EOT
      kubernetes_env_file=.env.kubernetes.production
      rm -f $kubernetes_env_file
      touch $kubernetes_env_file
      echo 'RUBY_DOCKER_APP_DATABASE_HOST=${aws_db_instance.default.address}' >> $kubernetes_env_file
      echo 'RAILS_ENV=production' >> $kubernetes_env_file
      echo 'MEMCACHED_SERVER=${module.elasticache.cluster_address}' >> $kubernetes_env_file
      echo 'CLOUDFRONT_DOMAIN_NAME=${module.cloudfront.domain_name}' >> $kubernetes_env_file
      echo 'S3_BUCKET=${module.s3.bucket_name}' >> $kubernetes_env_file
      echo 'RAILS_SERVE_STATIC_FILES=true' >> $kubernetes_env_file
    EOT
  }
}
