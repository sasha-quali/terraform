provider "aws" {
  region     = "eu-west-1"
  access_key = var.AWS_ACCESS_KEY == "none" ? "" : var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_ACCESS == "none" ? "" : var.AWS_SECRET_ACCESS
}

resource "aws_s3_bucket_object" "object" {
  bucket = var.BUCKET_NAME
  key = "${var.SANDBOX_ID_NEW}-hcl"
  acl = "bucket-owner-full-control"
  content = <<EOF
SERVER_NAME:${var.SERVER_NAME}
SERVER_VERSION:${var.SERVER_VERSION}
OUTPUTS_PUBLISHER_NO_HCL:${var.OUTPUTS_PUBLISHER_NO_HCL}
OUTPUTS_PUBLISHER_NUMBER:${var.OUTPUTS_PUBLISHER_NUMBER}
OUTPUTS_PUBLISHER_FRACTION:${var.OUTPUTS_PUBLISHER_FRACTION}
OUTPUTS_PUBLISHER_BOOL:${var.OUTPUTS_PUBLISHER_BOOL}
OUTPUTS_PUBLISHER_TUPLE_KEY2:${var.OUTPUTS_PUBLISHER_TUPLE[0]["key2"]}
OUTPUTS_PUBLISHER_TUPLE_NUM:${var.OUTPUTS_PUBLISHER_TUPLE[2]}
OUTPUTS_PUBLISHER_OBJECT_ELM:${var.OUTPUTS_PUBLISHER_OBJECT.symbol}
TF_INPUT_STRING:${var.TF_INPUT_STRING}
TF_INPUT_NUMBER:${var.TF_INPUT_NUMBER}
TF_INPUT_LIST:${var.TF_INPUT_LIST[0]}
TF_INPUT_MAP:${var.TF_INPUT_MAP["key1"]}
TF_INPUT_TUPLE:${var.TF_INPUT_TUPLE[0]["lmkey1"]}
TF_INPUT_OBJECT_STR:${var.TF_INPUT_OBJECT.symbol}
TF_INPUT_OBJECT_ELM:${var.TF_INPUT_OBJECT.levels[1]}
SANDBOX_ID_NEW:${var.SANDBOX_ID_NEW}
PUBLIC_ADDRESS_NEW:${var.PUBLIC_ADDRESS_NEW}
LITERAL_PARAMETER:${var.LITERAL_PARAMETER}
AWS_SSM_PARAMETER:${var.AWS_SSM_PARAMETER}
EOF
}

data "external" "presign" {
  program = ["bash", "presign.sh", var.BUCKET_NAME, "${var.SANDBOX_ID_NEW}-hcl", var.AWS_ACCESS_KEY, var.AWS_SECRET_ACCESS]
}

output "s3_file_url" {
  value = "${data.external.presign.result.url}"
}
