# Resume Website - Quick Setup

This repo builds a resume website automatically from LaTeX files.

## Quick Start

1. **Enable GitHub Pages:**
   - Go to Settings > Pages 
   - Set Source to "GitHub Actions"

2. **Update your info:**
   Edit `_data/config.yml`:
   ```yaml
   name: "Your Name"
   title: "Your Job Title"
   contact:
     email: "your@email.com"
     phone: "+1234567890"
     github: "your-github"
     linkedin: "your-linkedin"
   ```

3. **Add your resume:**
   - Put your `.tex` files in `resume/` folder
   - Update file names in `_data/config.yml`

4. **Deploy:**
   ```bash
   git add .
   git commit -m "Setup resume"
   git push
   ```

## Your site will be live at:
https://ata-the-legend.github.io/resume/

## Files to Edit:
- `_data/config.yml` - Your personal info
- `resume/*.tex` - Your LaTeX resume files
- `_config.yml` - Site settings (change baseurl if repo name differs)

## Test Locally:
```bash
./scripts/validate.sh  # Check setup
./scripts/build.sh build  # Build everything  
./scripts/build.sh serve  # Preview locally
```

## Need Help?
- Run `./scripts/validate.sh` to check for issues
- Check GitHub Actions tab for build logs
- See SETUP.md for detailed instructions

That's it! Simple and automated.
