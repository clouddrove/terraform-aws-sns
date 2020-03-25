<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS SNS
</h1>

<p align="center" style="font-size: 1.2rem;">
    Terraform module is used to setup SNS service to manage notifications on application.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v0.12-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="Licence">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-sns'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+SNS&url=https://github.com/clouddrove/terraform-aws-sns'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+SNS&url=https://github.com/clouddrove/terraform-aws-sns'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure.

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies:

- [Terraform 0.12](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-sns/releases).


Here are some examples of how you can use this module in your inventory structure:
### APNS
#### Basic
```hcl
  module "sns" {
    source            = "git::https://github.com/clouddrove/terraform-aws-sns.git?ref=tags/0.12.2"
    name              = "basic-sns"
    application       = "clouddrove"
    environment       = "test"
    label_order       = ["environment", "application", "name"]
    platform          = "APNS"
    key               = "../../certificates/private_key.pem"
    certificate       = "../../certificates/cert.pem"
  }
```
#### Complete
```hcl
  module "sns" {
    source            = "git::https://github.com/clouddrove/terraform-aws-sns.git?ref=tags/0.12.2"
    name              = "sns"
    application       = "clouddrove"
    environment       = "test"
    label_order       = ["environment", "application", "name"]
    platform          = "APNS"
    key               = file("../../certificates/private_key.pem")
    certificate       = file("../../certificates/cert.pem")
    topic_name        = "sns_topic"
    delivery_policy   = file("./../_json/delivery_policy.json")
    policy            = data.aws_iam_policy_document.sns-topic-policy.json
    endpoint          = "arn:aws:sqs:eu-west-1:xxxxxxxxxxx:dev-sqs-clouddrove"
    update_preference = true
    create_topic      = true
    protocol          = "sqs"
  }

  data "aws_iam_policy_document" "sns-topic-policy" {
    policy_id = "__default_policy_ID"
    statement {
      actions = [
        "SNS:Subscribe",
        "SNS:SetTopicAttributes",
        "SNS:RemovePermission",
        "SNS:Receive",
        "SNS:Publish",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:AddPermission",
      ]
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceOwner"

        values = [
          xxxxxxxxxxx,
        ]
      }
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      resources = [
        "arn:aws:sns:eu-west-1:xxxxxxxxxxx:sns_topic",
      ]
      sid = "__default_statement_ID"
    }
  }
```
### GCM
```hcl
  module "sns" {
    source      = "git::https://github.com/clouddrove/terraform-aws-sns.git?ref=tags/0.12.2"
    name        = "sqs"
    application = "clouddrove"
    environment = "test"
    label_order = ["environment", "application", "name"]
    platform    = "GCM"
    key         = "AAAAKHQaqe1w:APA91bEgwftAYq6N2YV8TeU2k4bRj0k1q2I7Q47ZvFPLQm-ESbD2Fhjj3U9wNNuZ2aC-QZVdgDrN5C6E3Ec08AWhMgbs4b72gNvqcXh1JBoR6yLwretghyjutTR4yRmT0vWdhz4_PW1AwDC0aVoH"
  }
```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application | Application \(e.g. `cd` or `clouddrove`\). | string | `""` | no |
| application\_failure\_feedback\_role\_arn | IAM role for failure feedback. | string | `""` | no |
| application\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | string | `""` | no |
| application\_success\_feedback\_sample\_rate | Percentage of success to sample. | number | `"100"` | no |
| attributes | Additional attributes \(e.g. `1`\). | list | `<list>` | no |
| certificate | application Platform principal. See Principal for type of principal required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources. | string | `""` | no |
| confirmation\_timeout\_in\_minutes | Integer indicating number of minutes to wait in retying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols. | number | `"60"` | no |
| default\_sender\_id | A string, such as your business brand, that is displayed as the sender on the receiving device. | string | `""` | no |
| default\_sms\_type | The type of SMS message that you will send by default. Possible values are: Promotional, Transactional. | string | `"Transactional"` | no |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | string | `"-"` | no |
| delivery\_policy | The SNS delivery policy. | string | `""` | no |
| delivery\_status\_iam\_role\_arn | The ARN of the IAM role that allows Amazon SNS to write logs about SMS deliveries in CloudWatch Logs. | string | `""` | no |
| delivery\_status\_success\_sampling\_rate | The percentage of successful SMS deliveries for which Amazon SNS will write logs in CloudWatch Logs. The value must be between 0 and 100. | string | `"50"` | no |
| display\_name | The display name for the SNS topic. | string | `""` | no |
| enable\_sms\_preference | Boolean indicating whether or not to update SNS SMS Preference. | bool | `"false"` | no |
| enable\_sns | Boolean indicating whether or not to create sns. | bool | `"true"` | no |
| enable\_topic | Boolean indicating whether or not to create topic. | bool | `"false"` | no |
| endpoint | The endpoint to send data to, the contents will vary with the protocol. | string | `""` | no |
| endpoint\_auto\_confirms | Boolean indicating whether the end point is capable of auto confirming subscription. | bool | `"false"` | no |
| environment | Environment \(e.g. `prod`, `dev`, `staging`\). | string | `""` | no |
| event\_delivery\_failure\_topic\_arn | SNS Topic triggered when a delivery to any of the platform endpoints associated with your platform application encounters a permanent failure. | string | `""` | no |
| event\_endpoint\_created\_topic\_arn | SNS Topic triggered when a new platform endpoint is added to your platform application. | string | `""` | no |
| event\_endpoint\_deleted\_topic\_arn | SNS Topic triggered when an existing platform endpoint is deleted from your platform application. | string | `""` | no |
| event\_endpoint\_updated\_topic\_arn | SNS Topic triggered when an existing platform endpoint is changed from your platform application. | string | `""` | no |
| failure\_feedback\_role\_arn | The IAM role permitted to receive failure feedback for this application. | string | `""` | no |
| filter\_policy | JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource. | string | `""` | no |
| gcm\_key | Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources. | string | `""` | no |
| http\_failure\_feedback\_role\_arn | IAM role for failure feedback. | string | `""` | no |
| http\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | string | `""` | no |
| http\_success\_feedback\_sample\_rate | Percentage of success to sample. | number | `"100"` | no |
| key | Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources. | string | `""` | no |
| kms\_master\_key\_id | The ID of an AWS-managed customer master key \(CMK\) for Amazon SNS or a custom CMK. For more information. | string | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | list | `<list>` | no |
| lambda\_failure\_feedback\_role\_arn | IAM role for failure feedback. | string | `""` | no |
| lambda\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | string | `""` | no |
| lambda\_success\_feedback\_sample\_rate | Percentage of success to sample. | number | `"100"` | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | string | `"anmol@clouddrove.com"` | no |
| monthly\_spend\_limit | The maximum amount in USD that you are willing to spend each month to send SMS messages. | number | `"1"` | no |
| name | Name  \(e.g. `app` or `cluster`\). | string | `""` | no |
| name\_prefix | The friendly name for the SNS topic. Conflicts with name. | string | `""` | no |
| platform | The platform that the app is registered with. See Platform for supported platforms like 'APNS' 'GCM'. | string | n/a | yes |
| platform\_principal | Application Platform principal. See Principal for type of principal required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources. | string | `""` | no |
| policy | The fully-formed AWS policy as JSON. For more information about building AWS IAM policy documents with Terraform. | string | `""` | no |
| protocol | The protocol to use. The possible values for this are: sqs, sms, lambda, application. | string | `""` | no |
| raw\_message\_delivery | Boolean indicating whether or not to enable raw message delivery. | bool | `"false"` | no |
| sqs\_failure\_feedback\_role\_arn | IAM role for failure feedback. | string | `""` | no |
| sqs\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | string | `""` | no |
| sqs\_success\_feedback\_sample\_rate | Percentage of success to sample. | number | `"100"` | no |
| subscription\_delivery\_policy | JSON String with the delivery policy \(retries, backoff, etc.\) that will be used in the subscription - this only applies to HTTP/S subscriptions. | string | `""` | no |
| success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this application. | string | `""` | no |
| success\_feedback\_sample\_rate | The percentage of success to sample \(0-100\). | number | `"100"` | no |
| tags | Additional tags \(e.g. map\(`BusinessUnit`,`XYZ`\). | map | `<map>` | no |
| topic\_name | The friendly name for the SNS topic. By default generated by Terraform. | string | `""` | no |
| usage\_report\_s3\_bucket | The name of the Amazon S3 bucket to receive daily SMS usage reports from Amazon SNS. | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the SNS platform application. |
| id | The ID of the SNS platform application. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system.

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-sns/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-sns)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
