# Flask in EC2 instances

Flask application powered by Waitress WSGI server to display a basic html website in an EC2 instance using NGINX to port forward HTTP calls to the html contents making it accessible to the internet from the EC2 public IP address.

The repo comes with configuration scripts for EC2 instance images for Amazon Linux, Ubuntu, and Windows. To use them, copy the script content inside the **User Data** section when creating the instance.

| AMI          | Script                                                       |
| ------------ | ------------------------------------------------------------ |
| Amazon Linux | [amazon_user-data.conf](./user-data/amazon-user_data.conf)   |
| Ubuntu       | [ubuntu_user-data.conf](./user-data/ubuntu-user_data.conf)   |
| Windows      | [windows_user-data.conf](./user-data/windows-user_data.conf) |
