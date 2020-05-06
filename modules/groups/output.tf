output "group_name1"{
    description = "flatten output values."
    value  = aws_iam_group.SparxEA.name
}
output "group_name2"{
    description = "flatten output values."
    value  = aws_iam_group.EC2_RDS.name
}
output "group_name3"{
    description = "flatten output values."
    value  = aws_iam_group.ViewBilling.name
}
output "local1"{
    description = "flatten output values."
    value  = local.policy_attachments 
}
