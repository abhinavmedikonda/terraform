resource "aws_iot_thing" "mac" {
  name = "mac"
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

resource "aws_iot_policy" "mac" {
  name = "MacPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iot:Publish",
        "iot:Receive",
        "iot:PublishRetain"
      ],
      "Resource": [
        "arn:aws:iot:us-east-1:300844397244:topic/sdk/test/java",
        "arn:aws:iot:us-east-1:300844397244:topic/sdk/test/python",
        "arn:aws:iot:us-east-1:300844397244:topic/sdk/test/js"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iot:Subscribe"
      ],
      "Resource": [
        "arn:aws:iot:us-east-1:300844397244:topicfilter/sdk/test/java",
        "arn:aws:iot:us-east-1:300844397244:topicfilter/sdk/test/python",
        "arn:aws:iot:us-east-1:300844397244:topicfilter/sdk/test/js"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iot:Connect"
      ],
      "Resource": [
        "arn:aws:iot:us-east-1:300844397244:client/sdk-java",
        "arn:aws:iot:us-east-1:300844397244:client/basicPubSub",
        "arn:aws:iot:us-east-1:300844397244:client/sdk-nodejs-*"
      ]
    }
  ]
}
EOF
}
