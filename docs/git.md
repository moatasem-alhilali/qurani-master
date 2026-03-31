أكيد!
هذه نسخة README احترافية **بالإنجليزية**،
تشمل كل السيناريوهات (private/public repo workflow)،
مع أمثلة استخدام موسعة،
وأكثر المشاكل الشائعة وحلولها.

---

````markdown
# Managing Code Between a Private and Public Repository

## 📚 Overview
- **Private Repo:** Contains the complete project including all sensitive files (Firebase configs, keystore, secrets, etc). Use this for daily development and as your secure "source of truth."
- **Public Repo:** Contains only the public code (NO secrets or sensitive files). Use this for open-source sharing, recruiting, or distributing code safely.

---

## 🏗️ Workflow Setup

### 1. Adding Remotes

#### A. Add the Public Remote

```bash
git remote add origin https://github.com/USERNAME/REPO_PUBLIC.git
````

#### B. Add the Private Remote

```bash
git remote add private https://github.com/USERNAME/REPO_PRIVATE.git
```

Check your remotes:

```bash
git remote -v
```

---

### 2. Day-to-Day Development & Pushing Changes

#### ✅ Daily Development

* Do all development in the **private** repo (`private`).
* You may include any files, including sensitive configurations, secrets, and keys.

#### ✅ Push to the Private Repo

```bash
git push private main
```

#### ✅ Push Code Only to the Public Repo

1. Make sure your `.gitignore` EXCLUDES all sensitive files (e.g.):

   ```
   lib/firebase_options.dart
   android/app/google-services.json
   android/app/release.keystore
   ios/Runner/GoogleService-Info.plist
   ```
2. Push:

   ```bash
   git push origin main
   ```

---

### 3. Removing Sensitive Files from the Public Repo (One Time)

If you accidentally committed secrets to the public repo:

```bash
git rm --cached lib/firebase_options.dart
git rm --cached android/app/google-services.json
git rm --cached android/app/release.keystore
git rm --cached ios/Runner/GoogleService-Info.plist
git commit -m "Remove sensitive files from public repo"
git push origin main
```

---

### 4. Syncing Code From Public to Private (Rarely Needed)

If you (or your team) made changes in the **public** repo and want to merge them into your private repo:

```bash
git fetch origin
git merge origin/main
git push private main
```

Or, for a fast-forward only:

```bash
git pull origin main
git push private main
```

---

### 5. Typical Workflow for Every New Change

1. Make all changes (including secrets) in the **private** repo.
2. Commit as usual:

   ```bash
   git add .
   git commit -m "New feature or fix"
   ```
3. Push everything to the private repo:

   ```bash
   git push private main
   ```
4. Push the code (excluding secrets) to the public repo:

   ```bash
   git push origin main
   ```
5. Repeat for every feature, fix, or update.

---

## ⚠️ Security Tips

* **Never push sensitive files to the public repo!**
* Always maintain an up-to-date `.gitignore`.
* Prefer to work from the private repo and only push "clean" code to public.
* If a secret is ever exposed, rotate it immediately!

---

## 🔄 Practical Usage Scenarios

### Example 1: Day-to-Day Development

* Add new features or fix bugs in your private repo (with all configs present).
* Push changes:

  ```bash
  git push private main
  ```
* After confirming everything is safe, update the public repo:

  ```bash
  git push origin main
  ```

### Example 2: Sharing Your Code

* You want to share your codebase or show it to a recruiter.
* **Do NOT include secrets.**
* Only push from private to public after double-checking your `.gitignore`.

### Example 3: Switching Machines

* Clone your private repo on a new machine for full development:

  ```bash
  git clone https://github.com/USERNAME/REPO_PRIVATE.git
  ```
* Clone your public repo on any untrusted or shared device (no secrets included):

  ```bash
  git clone https://github.com/USERNAME/REPO_PUBLIC.git
  ```

### Example 4: Merging Public Contributions

* If someone makes a PR or direct commit to your public repo, you can safely merge it into your private repo (see Syncing Code above).

---

## 🧩 Common Problems & Solutions

**Problem:**
`error: failed to push some refs to ... (non-fast-forward)`
**Solution:**

* You probably have new commits on the remote that you don't have locally.
  Pull and merge before pushing:

  ```bash
  git pull private main --allow-unrelated-histories
  git push private main
  ```

---

**Problem:**
You accidentally pushed secrets to the public repo.
**Solution:**

* Immediately remove the files from git history and rotate the secrets if necessary.
* Use `git rm --cached <file>` and push again.
* Consider using [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) to scrub secrets from history.

---

**Problem:**
Colleagues accidentally push secrets to public.
**Solution:**

* Add a pre-commit or pre-push hook to prevent this (ask if you need a sample script).
* Regularly review `.gitignore` and educate your team.

---

## 🏁 Summary

With this dual-repository workflow:

* Your sensitive information stays **safe**.
* Your code is **shareable and clean**.
* You have full control over what gets published.

**Need advanced sync, multi-branch strategies, or pre-commit hooks? Ask for tailored instructions!**

```

---

