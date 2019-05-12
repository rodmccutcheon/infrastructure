/*====
RDS
======*/

/* subnet used by rds */
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = ["${var.subnet_ids}"]
}

resource "aws_db_instance" "sonarqube-rds" {
  identifier             = "sonarqube-database"
  allocated_storage      = "${var.allocated_storage}"
  engine                 = "postgres"
  engine_version         = "11.2"
  instance_class         = "${var.instance_class}"
  multi_az               = "${var.multi_az}"
  name                   = "${var.database_name}"
  username               = "${var.database_username}"
  password               = "${var.database_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.rds_subnet_group.id}"
  # vpc_security_group_ids = ["${aws_security_group.jenkins_sonarqube_vpc_sg.id}"]
  vpc_security_group_ids = ["sg-012911a9f86211e5d"]
  snapshot_identifier     = "snapshot_name"
  final_snapshot_identifier = "final-snapshot-name"
  skip_final_snapshot = true
  # tags {
  #   Environment = "${var.environment}"
  # }
}

output "rds_address" {
  value = "${aws_db_instance.sonarqube-rds.address}"
}