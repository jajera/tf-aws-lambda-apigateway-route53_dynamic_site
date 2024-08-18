# tf-aws-lambda-apigateway-route53_dynamic_site

## build

```bash
domain="mydomain.cloud"
```

```terraform
terraform init
```

```terraform
terraform apply --auto-approve -var "domain=${domain} -target=aws_acm_certificate.web
```

```terraform
terraform apply --auto-approve -var "domain=${domain}
```

## test

### colors page

return all colors

```bash
curl -s https://mydomain.cloud/colors | jq
```

```json
{
  "message": "Success",
  "result": [
    {
      "id": 1,
      "name": "Red",
      "hex": "#FF0000"
    },
    {
      "id": 2,
      "name": "Green",
      "hex": "#00FF00"
    },
    {
      "id": 3,
      "name": "Blue",
      "hex": "#0000FF"
    },
    {
      "id": 4,
      "name": "Yellow",
      "hex": "#FFFF00"
    },
    {
      "id": 5,
      "name": "Cyan",
      "hex": "#00FFFF"
    },
    {
      "id": 6,
      "name": "Magenta",
      "hex": "#FF00FF"
    },
    {
      "id": 7,
      "name": "Orange",
      "hex": "#FFA500"
    },
    {
      "id": 8,
      "name": "Purple",
      "hex": "#800080"
    }
  ]
}
```

return specific color

```bash
curl -s https://mydomain.cloud/colors/1 | jq
```

```json
{
  "message": "Success",
  "result": {
    "id": 1,
    "name": "Red",
    "hex": "#FF0000"
  }
}
```

add new color (NOTE: This addition is temporary as the data is stored only in memory.)

```bash
curl -X POST https://mydomain.cloud/colors \
  -H "Content-Type: application/json" \
  -d '{
    "id": 9,
    "name": "Pink",
    "hex": "#FFC0CB"
  }'
```

## cleanup

```terraform
terraform destroy --auto-approve -var "domain=${domain}
```
