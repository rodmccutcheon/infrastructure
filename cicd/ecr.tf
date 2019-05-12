resource "aws_ecr_repository" "ortjenkins" {
    name = "ortjenkins"
}

output "Registry URL" {
    value ="${aws_ecr_repository.ortjenkins.repository_url}"
}