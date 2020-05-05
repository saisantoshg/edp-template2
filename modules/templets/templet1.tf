data "templet_file" "user_policy_templet"{
  templet = "${file("iam_user_s3_inlinepolicy.json")}"
  vars = {
      bucket_name = "client-1A"
  }
}
