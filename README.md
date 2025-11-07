# Resume Website

This repository automatically builds and deploys a professional resume website using LaTeX source files and GitHub Pages.

## 🌐 Live Website

Visit the live resume at: [https://ata-the-legend.github.io/resume/](https://ata-the-legend.github.io/resume/)

## 🚀 Features

- **Automated PDF Generation**: LaTeX source files are automatically compiled to PDFs
- **Multiple Resume Versions**: Support for different resume variants (standard, simple, etc.)
- **Responsive Web Interface**: Beautiful, mobile-friendly resume viewer
- **GitHub Pages Deployment**: Automatic deployment on every commit
- **Configurable Settings**: Easy customization through YAML configuration
- **PDF Download**: Direct download links for all resume versions

## 📁 Repository Structure

```
├── resume/                          # LaTeX source files
│   ├── ata_safapour_resume_v3.0.0.tex
│   ├── ata_safapour_resume_v3.0.0_simple.tex
│   └── ata_safapour_resume_v3.0.0_fixed.tex
├── _data/
│   └── config.yml                   # Resume configuration
├── _layouts/
│   └── default.html                 # Jekyll layout template
├── .github/workflows/
│   └── deploy.yml                   # GitHub Actions workflow
├── _config.yml                      # Jekyll configuration
├── index.md                         # Main page template
└── README.md                        # This file
```

## ⚙️ Configuration

### Resume Settings (`_data/config.yml`)

Edit `_data/config.yml` to customize your resume website:

```yaml
# Basic Information
name: "Your Name"
title: "Your Title"
description: "Your professional description"

# Resume Settings
resume:
  primary_version: "your_resume_file_name"
  versions:
    - name: "Standard Version"
      file: "your_resume_file_name"
      description: "Full professional resume"

# Contact Information
contact:
  phone: "+1 234 567 8900"
  email: "your.email@example.com"
  linkedin: "your-linkedin"
  github: "your-github"

# Display Settings
display:
  show_last_updated: true
  show_download_button: true
  show_version_selector: true
```

### Site Configuration (`_config.yml`)

Basic Jekyll site configuration:

```yaml
title: "Your Name - Resume"
description: "Your professional description"
baseurl: "/resume"  # Change if your repo has a different name
url: "https://yourusername.github.io"
```

## 🔧 Setup Instructions

### 1. Fork/Clone Repository

```bash
git clone https://github.com/ata-the-legend/resume.git
cd resume
```

### 2. Add Your Resume Files

Place your LaTeX resume files in the `resume/` directory:

```bash
# Example structure
resume/
├── your_resume_main.tex
├── your_resume_simple.tex
└── your_resume_academic.tex
```

### 3. Update Configuration

Edit `_data/config.yml` with your information:

- Personal details (name, contact info)
- Resume file names and descriptions
- Display preferences

### 4. Enable GitHub Pages

1. Go to your repository settings
2. Navigate to **Pages** section
3. Set source to **GitHub Actions**
4. The site will be available at: `https://yourusername.github.io/repositoryname/`

### 5. Customize Styling (Optional)

Edit `_layouts/default.html` to customize:

- Colors and fonts
- Layout and spacing  
- Additional features

## 🏗️ How It Works

### Automated Pipeline

1. **Trigger**: Push to main/master branch
2. **LaTeX Compilation**: GitHub Actions compiles all `.tex` files to PDFs
3. **Jekyll Build**: Generates the website using templates and configuration
4. **Deployment**: Publishes to GitHub Pages automatically

### GitHub Actions Workflow

The workflow (`deploy.yml`) performs:

1. **LaTeX Build Job**:
   - Installs LaTeX packages
   - Compiles all resume files to PDFs
   - Uploads PDFs as artifacts

2. **Site Build Job**:
   - Sets up Jekyll environment
   - Downloads PDF artifacts
   - Builds the website
   - Uploads site artifacts

3. **Deploy Job**:
   - Deploys to GitHub Pages (main branch only)

## 📝 Adding New Resume Versions

1. Add your new LaTeX file to the `resume/` directory
2. Update `_data/config.yml`:
   ```yaml
   resume:
     versions:
       - name: "New Version Name"
         file: "new_resume_file_name"  # without .tex extension
         description: "Description of this version"
   ```
3. Commit and push - the new version will be automatically built and deployed

## 🎨 Customization

### Colors and Theme

Edit CSS variables in `_layouts/default.html`:

```css
:root {
    --primary-color: #0e6e55;      /* Main brand color */
    --background-color: #ffffff;    /* Background */
    --text-color: #333;             /* Text color */
    /* ... other variables */
}
```

### Layout and Sections

Modify `index.md` to:
- Add new sections
- Change content layout
- Update contact information display

### PDF Compilation Settings

Adjust LaTeX compilation in `.github/workflows/deploy.yml`:
- Add required packages
- Modify compilation commands
- Handle special LaTeX requirements

## 🐛 Troubleshooting

### Common Issues

**LaTeX Compilation Fails**:
- Check package dependencies in workflow file
- Verify LaTeX syntax in source files
- View GitHub Actions logs for specific errors

**Website Not Loading**:
- Ensure GitHub Pages is enabled
- Check repository name matches `baseurl` in `_config.yml`
- Verify workflow completed successfully

**PDFs Not Displaying**:
- Confirm PDFs were generated (check Actions artifacts)
- Verify file names match configuration
- Test PDF files are valid

### Debugging

1. Check GitHub Actions logs for build errors
2. Test LaTeX compilation locally:
   ```bash
   cd resume
   pdflatex your_resume.tex
   ```
3. Test Jekyll build locally:
   ```bash
   bundle exec jekyll serve
   ```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📧 Support

If you encounter issues or have questions:

1. Check the [Issues](https://github.com/ata-the-legend/resume/issues) page
2. Create a new issue with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs/screenshots

---

**Built with ❤️ using LaTeX, Jekyll, and GitHub Actions**
