/* module for creating s3 buckets and managing them */

resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy_enabled
}

resource "aws_s3_bucket_public_access_block" "block_access" {
  count               = var.block_public_access ? 1 : 0
  bucket              = aws_s3_bucket.bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

resource "aws_iam_user" "bucket_user" {
  count = var.create_user_access_credentials ? 1 : 0
  name  = "${var.bucket_name}-bucket-access-user"
}

resource "aws_iam_user_policy" "bucket_access_policy" {
  count = var.create_user_access_credentials ? 1 : 0

  name = "${var.bucket_name}-access-policy"
  user = aws_iam_user.bucket_user[0].name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ListObjectsInBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}"
        ]
      },
      {
        "Sid" : "AllObjectActions",
        "Effect" : "Allow",
        "Action" : "s3:*Object",
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "bucket_policy_attachment" {
  count      = var.create_user_access_credentials ? 1 : 0
  user       = aws_iam_user.bucket_user[0].name
  policy_arn = aws_iam_user_policy.bucket_access_policy.arn
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  count  = var.enable_bucket_versioning ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  count  = var.block_public_access ? 0 : 1
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_public_access_for_bucket.json
}

data "aws_iam_policy_document" "allow_public_access_for_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
}
