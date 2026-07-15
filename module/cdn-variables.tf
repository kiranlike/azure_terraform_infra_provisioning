variable "cdn_profile_name" {
  type    = string
  default = "cdn-profile"
  validation {
    condition     = length(var.cdn_profile_name) > 0
    error_message = "cdn_profile_name cannot be empty"
  }
}
variable "cdn_profile_sku" {
  type    = string
  default = "Standard_AzureFrontDoor"
  validation {
    condition     = length(var.cdn_profile_sku) > 0
    error_message = "cdn profile sku kind cannot be empty"
  }
}

variable "content_types_to_compress" {
  type = list(string)
  default = [
    "application/eot", "application/font", "application/font-sfnt", "application/javascript", "application/json", "application/opentype", "application/otf", "application/pkcs7-mime", "application/truetype", "application/ttf", "application/vnd.ms-fontobject", "application/xhtml+xml", "application/xml", "application/xml+rss", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/x-httpd-cgi", "application/x-javascript", "application/x-mpegurl", "application/x-opentype", "application/x-otf", "application/x-perl", "application/x-ttf", "font/eot", "font/ttf", "font/otf", "font/opentype", "image/svg+xml", "text/css", "text/csv", "text/html", "text/javascript", "text/js", "text/plain", "text/richtext", "text/tab-separated-values", "text/xml", "text/x-script", "text/x-component", "text/x-java-source"
  ]
  validation {
    condition     = length(var.content_types_to_compress) > 0
    error_message = "content_types_to_compress cannot be empty"
  }
}

variable "operatorweb_cdn_endpoint_name" {
  type    = string
  default = "operator-cdn-endpoint"
  validation {
    condition     = length(var.operatorweb_cdn_endpoint_name) > 0
    error_message = "operatorweb_cdn_endpoint_name name cannot be empty"
  }
}
variable "consumerweb_cdn_endpoint_name" {
  type    = string
  default = "consumer-cdn-endpoint"
  validation {
    condition     = length(var.consumerweb_cdn_endpoint_name) > 0
    error_message = "consumerweb_cdn_endpoint_name name cannot be empty"
  }
}


