
[References1](https://www.youtube.com/watch?v=ZP_vAbjfFMs)
[References2](https://www.youtube.com/watch?v=qwmprtAzJew)


To list available Aurora MySQL versions.\
`aws rds describe-db-engine-versions --engine aurora-mysql --query "DBEngineVersions[*].EngineVersion" --output table`

To list available Aurora PostgreSQL versions.\
`aws rds describe-db-engine-versions --engine aurora-postgresql --region us-east-1 --query "DBEngineVersions[*].EngineVersion" --output table`

To list versions of the regular MySQL database (non-Aurora).\
`aws rds describe-db-engine-versions --engine mysql --region us-east-1 --query "DBEngineVersions[*].EngineVersion" --output table`

For MariaDB.\
`aws rds describe-db-engine-versions --engine mariadb --region us-east-1 --query "DBEngineVersions[*].EngineVersion" --output table`

To check Oracle versions.\
`aws rds describe-db-engine-versions --engine oracle-se2 --region us-east-1 --query "DBEngineVersions[*].EngineVersion" --output table`

To list the instance types supported by Aurora MySQL.\
`aws rds describe-orderable-db-instance-options --engine aurora-mysql --region us-east-1 --query "OrderableDBInstanceOptions[*].DBInstanceClass" --output table`

To describe the instance db.r4.16xlarge and its details, such as the vCPUs, RAM.\
`aws ec2 describe-instance-types --instance-types r4.16xlarge --query "InstanceTypes[*].[InstanceType,VCpuInfo.DefaultVCpus,MemoryInfo.SizeInMiB]" --output table`


[aurora-ref-1](https://medium.com/@nagarjun_nagesh/terraform-aurora-rds-cluster-on-aws-612e797d7471)