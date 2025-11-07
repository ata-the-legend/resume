# Quick Setup Guide

## 🚀 Quick Start

This repository is ready for GitHub Pages deployment! Here's how to get started:

### 1. **Enable GitHub Pages**
1. Go to your repository **Settings**
2. Scroll to **Pages** section  
3. Set **Source** to "GitHub Actions"
4. Save the settings

### 2. **Configure Your Information**
Edit `_data/config.yml` with your details:

```yaml
# Update these with your information
name: "Your Full Name"
title: "Your Professional Title"  
description: "Brief professional description"

# Update contact information
contact:
  phone: "+1 234 567 8900"
  email: "your.email@example.com"
  linkedin: "your-linkedin-username"
  github: "your-github-username"
```

### 3. **Add Your Resume Files**
Place your LaTeX resume files in the `resume/` folder and update the configuration:

```yaml
resume:
  primary_version: "your_resume_main"  # without .tex extension
  versions:
    - name: "Standard Version"
      file: "your_resume_main"
      description: "Full professional resume"
    - name: "Academic Version"  
      file: "your_resume_academic"
      description: "Academic-focused version"
```

### 4. **Test Locally (Optional)**
```bash
# Validate configuration
./scripts/validate.sh

# Build and test locally
./scripts/build.sh build
./scripts/build.sh serve
```

### 5. **Deploy**
```bash
git add .
git commit -m "Setup resume website"
git push origin main
```

Your resume will be live at: `https://yourusername.github.io/repositoryname/`

## 📁 File Overview

- **`_data/config.yml`** - Your personal information and settings
- **`resume/*.tex`** - Your LaTeX resume files  
- **`_config.yml`** - Jekyll site configuration
- **`.github/workflows/deploy.yml`** - Automated build and deployment

## 🔧 Customization

### Change Colors
Edit the CSS variables in `_layouts/default.html`:

```css
:root {
    --primary-color: #0e6e55;  /* Your brand color */
    --background-color: #ffffff;
    /* ... other colors */
}
```

### Update Site Title
Edit `_config.yml`:

```yaml
title: "Your Name - Resume"
baseurl: "/your-repo-name"  # Must match your repository name
url: "https://yourusername.github.io"
```

## 📞 Need Help?

1. Run `./scripts/validate.sh` to check your configuration
2. Check the [full README](README.md) for detailed instructions
3. Look at GitHub Actions logs if deployment fails
4. Open an issue if you need assistance

---

**Ready to go? Just update the config files and push to deploy! 🚀**
