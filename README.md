# Team4tech Automation Scripts

Rotex Automation Scripts

Project Overview

This repository contains Bash scripts to automate common DevOps/IT tasks, such as copying files and uploading to S3. Scripts are safe to run multiple times, handle errors, and provide logs.

Setup Instructions

Clone the repository:

git clone https://github.com/<username>/rotex-automation-scripts.git
cd rotex-automation-scripts

Make scripts executable:
chmod +x *.sh

(Optional) Install AWS CLI for S3 scripts.

Script Documentation

File Copy Script

./rotex-automation_file_copy.sh <source_file> <target_directory>
Copies a file to the target directory.

Logs actions to the console.

S3 Upload Script

./s3_file_upload.sh <source_file> <s3_bucket_name>
Uploads a file to an S3 bucket.

Requires AWS CLI configured.

Contribution Guidelines

Fork the repo and create a branch:
git checkout -b feature/<name>

Make changes and commit:
git commit -m "Add description"

Push branch and open a Pull Request.

All scripts should include logging, error handling, and be idempotent.
