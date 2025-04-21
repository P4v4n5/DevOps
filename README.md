# DevOps

## 🔍 **Monitoring GitHub Repository Access with Shell Script in DevOps Workflows**

> How a simple Bash script can enhance visibility, security, and collaboration in modern DevOps pipelines

---

### 👋 Introduction

In any software development environment—especially in fast-moving DevOps teams—**knowing who has access to your codebase is critical**. Whether it's open-source collaboration, internal microservices, or infrastructure-as-code, you need clear visibility over your GitHub repositories' access control.

This article introduces a simple but powerful **shell script** that queries GitHub's API to list all users with **read access** to a given repository. We'll walk through how it's built, how to set it up on an Amazon Linux machine, and why it matters.

---

### 🔧 The Use Case: Why Should You Care?

Let’s imagine you’re a DevOps engineer managing multiple GitHub repositories across teams. You’re responsible for:

- Ensuring only authorized users have access
- Auditing contributor access as part of compliance checks
- Automating reporting on repo-level permissions

In such scenarios, **manual verification isn’t scalable**. Instead, we automate the audit process using GitHub APIs + shell scripting.

---

### 💡 What This Script Does

This script:
- Accepts a GitHub `repo_owner` and `repo_name` as command-line arguments
- Authenticates via a GitHub personal access token
- Calls the GitHub API to list all **collaborators with at least read access**
- Outputs them in a clean, readable format

---

### 🧠 Script Breakdown

```bash
#!/bin/bash
set -e
```
We start by telling the script to **exit immediately on any error**, ensuring robust execution.

---

```bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi
```
This ensures the user provides both required inputs—repository owner and repository name.

---

```bash
if [[ -z "$username" || -z "$token" ]]; then
    echo "Error: Please export your GitHub username and token:"
    echo "  export username=your_username"
    echo "  export token=your_token"
    exit 1
fi
```
We **validate credentials** from environment variables, which is safer than hardcoding.

---

```bash
function github_api_get {
    local endpoint="$1"
    curl -s -u "${username}:${token}" "${API_URL}/${endpoint}"
}
```
Reusable function to hit any GitHub API endpoint using `curl`.

---

```bash
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    collaborators=$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')
    ...
}
```
Uses the GitHub REST API to list **collaborators**, filters them by `permissions.pull == true` using `jq`, and prints only those with read access.

---

### 🚀 How to Run This Script

1. **Set your GitHub credentials** (use a personal access token with `repo` scope):
```bash
export username=your_username
export token=your_personal_access_token
```

2. **Run the script with owner and repo**:
```bash
./list_contributors.sh octocat Hello-World
```

✅ Output:
```
Listing users with read access to octocat/Hello-World...
Users with read access:
johndoe
janedoe
```

---

### 🛡️ Real-World Impact

| 📌 Use Case | 💥 Value |
|------------|----------|
| Security Audits | Quickly verify who can access a private repo |
| CI/CD Compliance | Integrate into pre-deployment checks |
| Access Governance | Detect stale or unauthorized access |
| Collaboration Management | Ensure all stakeholders are included (and only them!) |

You can easily schedule this script via **cron**, **GitHub Actions**, or integrate it with **CloudWatch** for alerting on access changes.

---

### ☁️ Bonus: Run It from Amazon Linux (EC2)

1. Launch an **Amazon Linux 2 EC2 instance**
2. Install necessary tools:
```bash
sudo yum install -y jq curl
```
3. Clone the script or upload it via `scp`
4. Run it using the steps above

This makes your access-checking script **cloud-native and production-ready** 💪

---

### 🧩 Possible Extensions

- Save results to a file and upload to **S3**
- Compare historical access with diffs
- Send Slack/email alerts if new users are detected
- Extend to list `admin` or `write` permission holders

---

### ✅ Conclusion

Incorporating simple automation like this into your DevOps workflows can dramatically reduce manual errors, boost transparency, and improve security. With GitHub becoming central to both code and infrastructure, **visibility is no longer optional—it’s essential**.

Happy scripting! 🐧

---
