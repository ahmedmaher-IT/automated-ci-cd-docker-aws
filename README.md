# CI/CD Pipeline — Dockerized Flask App on AWS EC2

A full CI/CD pipeline using **Jenkins**, **Docker**, **Terraform**, and **AWS EC2** to automate build, test, and deployment of a Python Flask application.

---

## Architecture

```
GitHub Push → Jenkins Pipeline → Docker Build → DockerHub → Deploy to EC2
                                                               ↑
                                              Terraform provisions EC2
```

## Tech Stack

| Tool        | Purpose                              |
|-------------|--------------------------------------|
| Python/Flask | Web application                    |
| Docker       | Containerization                   |
| DockerHub    | Container image registry           |
| Jenkins      | CI/CD automation                   |
| Terraform    | Infrastructure as Code (EC2)       |
| AWS EC2      | Deployment target                  |

---

## Pipeline Stages

1. **Checkout** — Clone the repository
2. **Test** — Run unit tests with pytest
3. **Build** — Build Docker image tagged with build number
4. **Push** — Push image to DockerHub automatically
5. **Deploy** — Pull latest image and run container on EC2

---

## Project Structure

```
cicd-pipeline-project/
├── app/
│   ├── app.py            # Flask application
│   ├── test_app.py       # Unit tests (pytest)
│   └── requirements.txt
├── terraform/
│   ├── main.tf           # EC2 + Security Group
│   ├── variables.tf
│   └── outputs.tf
├── Dockerfile
├── Jenkinsfile           # Pipeline definition
└── README.md
```

---

## Setup & Usage

### 1. Provision EC2 with Terraform

```bash
cd terraform

# Create terraform.tfvars (not committed to git)
echo 'key_pair_name = "your-key-pair-name"' > terraform.tfvars

terraform init
terraform plan
terraform apply
```

Copy the `ec2_public_ip` from the output.

### 2. Configure Jenkins Credentials

In Jenkins → Manage Jenkins → Credentials, add:

| ID                    | Type              | Value                        |
|-----------------------|-------------------|------------------------------|
| `dockerhub-credentials` | Username/Password | DockerHub username + password |
| `ec2-host`            | Secret text       | EC2 public IP from Terraform |
| `ec2-ssh-key`         | SSH private key   | Your `.pem` key file         |

### 3. Create Jenkins Pipeline

- New Item → Pipeline
- Pipeline definition: **Pipeline script from SCM**
- SCM: Git → your repo URL
- Script path: `Jenkinsfile`

### 4. Trigger the Pipeline

Push any commit to the repository — Jenkins will automatically:
- Run tests
- Build and push the Docker image
- Deploy to EC2

### 5. Access the App

```
http://<EC2_PUBLIC_IP>/
http://<EC2_PUBLIC_IP>/health
```

---

## Local Development

```bash
# Run app locally
pip install -r app/requirements.txt
python app/app.py

# Run with Docker
docker build -t flask-cicd-app .
docker run -p 5000:5000 flask-cicd-app

# Run tests
cd app && pytest test_app.py -v
```

---

## Author

Ahmed Maher — [LinkedIn](https://linkedin.com/in/your-profile) | [GitHub](https://github.com/your-username)
