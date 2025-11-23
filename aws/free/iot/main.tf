resource "aws_iot_thing" "mac" {
  name = "mac"
}

resource "aws_iot_policy" "mac" {
  name = "MacPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["iot:Connect", "iot:Publish", "iot:Receive", "iot:Subscribe"],
    "Resource": "*"
  }]
}
EOF
}

# uploading custom certificate:
resource "aws_iot_certificate" "mac" {
  certificate_pem = file("${path.module}/device-certificate.crt")
  active          = true
}

resource "aws_iot_policy_attachment" "mac" {
  policy = aws_iot_policy.mac.name
  target = aws_iot_certificate.mac.arn
}

resource "aws_iot_thing_principal_attachment" "mac" {
  thing     = aws_iot_thing.mac.name
  principal = aws_iot_certificate.mac.arn
}