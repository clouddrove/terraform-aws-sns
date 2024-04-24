## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_failure\_feedback\_role\_arn | IAM role for failure feedback. | `string` | `""` | no |
| application\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | `string` | `""` | no |
| application\_success\_feedback\_sample\_rate | Percentage of success to sample. | `number` | `100` | no |
| certificate | application Platform principal. See Principal for type of principal required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources. | `string` | `""` | no |
| content\_based\_deduplication | Boolean indicating whether or not to enable content-based deduplication for FIFO topics. | `bool` | `false` | no |
| create\_topic\_policy | Determines whether an SNS topic policy is created | `bool` | `true` | no |
| data\_protection\_policy | A map of data protection policy statements | `string` | `null` | no |
| default\_sender\_id | A string, such as your business brand, that is displayed as the sender on the receiving device. | `string` | `""` | no |
| default\_sms\_type | The type of SMS message that you will send by default. Possible values are: Promotional, Transactional. | `string` | `"Transactional"` | no |
| delivery\_policy | The SNS delivery policy. | `string` | `null` | no |
| delivery\_status\_iam\_role\_arn | The ARN of the IAM role that allows Amazon SNS to write logs about SMS deliveries in CloudWatch Logs. | `string` | `""` | no |
| delivery\_status\_success\_sampling\_rate | The percentage of successful SMS deliveries for which Amazon SNS will write logs in CloudWatch Logs. The value must be between 0 and 100. | `number` | `50` | no |
| display\_name | The display name for the SNS topic. | `string` | `""` | no |
| enable\_default\_topic\_policy | Specifies whether to enable the default topic policy. Defaults to `true` | `bool` | `true` | no |
| enable\_sms\_preference | Boolean indicating whether or not to update SNS SMS Preference. | `bool` | `false` | no |
| enable\_sns | Boolean indicating whether or not to create sns. | `bool` | `false` | no |
| enable\_topic | Boolean indicating whether or not to create topic. | `bool` | `false` | no |
| enabled | Boolean indicating whether or not to create sns module. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| event\_delivery\_failure\_topic\_arn | SNS Topic triggered when a delivery to any of the platform endpoints associated with your platform application encounters a permanent failure. | `string` | `""` | no |
| event\_endpoint\_created\_topic\_arn | SNS Topic triggered when a new platform endpoint is added to your platform application. | `string` | `""` | no |
| event\_endpoint\_deleted\_topic\_arn | SNS Topic triggered when an existing platform endpoint is deleted from your platform application. | `string` | `""` | no |
| event\_endpoint\_updated\_topic\_arn | SNS Topic triggered when an existing platform endpoint is changed from your platform application. | `string` | `""` | no |
| failure\_feedback\_role\_arn | The IAM role permitted to receive failure feedback for this application. | `string` | `""` | no |
| fifo\_topic | Boolean indicating whether or not to create a FIFO (first-in-first-out) topic | `bool` | `false` | no |
| gcm\_key | Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources. | `string` | `""` | no |
| http\_failure\_feedback\_role\_arn | IAM role for failure feedback. | `string` | `""` | no |
| http\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | `string` | `""` | no |
| http\_success\_feedback\_sample\_rate | Percentage of success to sample. | `number` | `100` | no |
| key | Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources. | `string` | `""` | no |
| kms\_master\_key\_id | The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. For more information. | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| lambda\_failure\_feedback\_role\_arn | IAM role for failure feedback. | `string` | `""` | no |
| lambda\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | `string` | `""` | no |
| lambda\_success\_feedback\_sample\_rate | Percentage of success to sample. | `number` | `100` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| monthly\_spend\_limit | The maximum amount in USD that you are willing to spend each month to send SMS messages. | `number` | `1` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| override\_topic\_policy\_documents | List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid` | `list(string)` | `[]` | no |
| platform | The platform that the app is registered with. See Platform for supported platforms like 'APNS' 'GCM'. | `string` | `""` | no |
| policy | The fully-formed AWS policy as JSON. For more information about building AWS IAM policy documents with Terraform. | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-sns"` | no |
| signature\_version | If SignatureVersion should be 1 (SHA1) or 2 (SHA256). The signature version corresponds to the hashing algorithm used while creating the signature of the notifications, subscription confirmations, or unsubscribe confirmation messages sent by Amazon SNS. | `number` | `null` | no |
| source\_topic\_policy\_documents | List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s | `list(string)` | `[]` | no |
| sqs\_failure\_feedback\_role\_arn | IAM role for failure feedback. | `string` | `""` | no |
| sqs\_success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this topic. | `string` | `""` | no |
| sqs\_success\_feedback\_sample\_rate | Percentage of success to sample. | `number` | `100` | no |
| subscribers | Required configuration for subscibres to SNS topic. | <pre>map(object({<br>    protocol = string<br>    # The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported, see below) (email is an option but is unsupported, see below).<br>    endpoint = string<br>    # The endpoint to send data to, the contents will vary with the protocol. (see below for more information)<br>    endpoint_auto_confirms = bool<br>    # Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)<br>    raw_message_delivery = bool<br>    # Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)<br>    filter_policy = string<br>    # JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource.<br>    delivery_policy = string<br>    # The SNS delivery policy<br>    confirmation_timeout_in_minutes = string<br>    # Integer indicating number of minutes to wait in retying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols.<br>  }))</pre> | `{}` | no |
| success\_feedback\_role\_arn | The IAM role permitted to receive success feedback for this application. | `string` | `""` | no |
| success\_feedback\_sample\_rate | The percentage of success to sample (0-100). | `number` | `100` | no |
| topic\_policy\_statements | A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage | `any` | `{}` | no |
| tracing\_config | Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active. | `string` | `null` | no |
| usage\_report\_s3\_bucket | The name of the Amazon S3 bucket to receive daily SMS usage reports from Amazon SNS. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the SNS platform application. |
| id | The ID of the SNS platform application. |
| topic-arn | The ARN of the SNS topic. |
| topic-id | The ID of the SNS topic. |

