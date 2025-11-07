#!/bin/bash

# Resume Configuration Validator
# This script validates the resume configuration and checks for common issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "🔍 Resume Configuration Validator"
echo "================================"

# Check if we're in the right directory
if [ ! -f "_config.yml" ] || [ ! -d "_data" ]; then
    print_error "Please run this script from the repository root directory"
    exit 1
fi

errors=0
warnings=0

# Check Jekyll configuration
print_status "Checking Jekyll configuration (_config.yml)..."

if [ ! -f "_config.yml" ]; then
    print_error "Jekyll configuration file _config.yml is missing"
    errors=$((errors + 1))
else
    # Check for required fields
    if ! grep -q "title:" _config.yml; then
        print_warning "Missing 'title' in _config.yml"
        warnings=$((warnings + 1))
    fi
    
    if ! grep -q "baseurl:" _config.yml; then
        print_warning "Missing 'baseurl' in _config.yml"
        warnings=$((warnings + 1))
    fi
    
    print_success "Jekyll configuration file exists"
fi

# Check resume data configuration
print_status "Checking resume data configuration (_data/config.yml)..."

if [ ! -f "_data/config.yml" ]; then
    print_error "Resume data file _data/config.yml is missing"
    errors=$((errors + 1))
else
    # Extract primary version from config
    primary_version=$(grep "primary_version:" _data/config.yml | sed 's/.*primary_version: *["\(]*\([^"]*\)["\)]*.*/\1/' | head -1)
    
    if [ -z "$primary_version" ]; then
        print_error "Primary version not specified in _data/config.yml"
        errors=$((errors + 1))
    else
        print_status "Primary version: $primary_version"
        
        # Check if primary version file exists
        if [ ! -f "resume/${primary_version}.tex" ]; then
            print_error "Primary version file resume/${primary_version}.tex not found"
            errors=$((errors + 1))
        else
            print_success "Primary version file exists"
        fi
    fi
    
    # Check for required fields
    required_fields=("name:" "title:" "description:")
    for field in "${required_fields[@]}"; do
        if ! grep -q "$field" _data/config.yml; then
            print_warning "Missing '$field' in _data/config.yml"
            warnings=$((warnings + 1))
        fi
    done
    
    # Check contact information
    contact_fields=("email:" "phone:" "github:" "linkedin:")
    for field in "${contact_fields[@]}"; do
        if ! grep -q "$field" _data/config.yml; then
            print_warning "Missing contact '$field' in _data/config.yml"
            warnings=$((warnings + 1))
        fi
    done
fi

# Check resume directory
print_status "Checking resume directory..."

if [ ! -d "resume" ]; then
    print_error "Resume directory not found"
    errors=$((errors + 1))
else
    tex_count=$(find resume -name "*.tex" | wc -l)
    if [ "$tex_count" -eq 0 ]; then
        print_error "No LaTeX (.tex) files found in resume directory"
        errors=$((errors + 1))
    else
        print_success "Found $tex_count LaTeX file(s)"
        
        # List all tex files
        print_status "LaTeX files found:"
        for tex_file in resume/*.tex; do
            if [ -f "$tex_file" ]; then
                echo "  - $(basename "$tex_file")"
            fi
        done
    fi
fi

# Check layout file
print_status "Checking Jekyll layout..."

if [ ! -f "_layouts/default.html" ]; then
    print_error "Jekyll layout file _layouts/default.html is missing"
    errors=$((errors + 1))
else
    print_success "Jekyll layout file exists"
fi

# Check index file
print_status "Checking index page..."

if [ ! -f "index.md" ] && [ ! -f "index.html" ]; then
    print_error "No index page found (index.md or index.html)"
    errors=$((errors + 1))
else
    print_success "Index page exists"
fi

# Check GitHub Actions workflow
print_status "Checking GitHub Actions workflow..."

if [ ! -f ".github/workflows/deploy.yml" ]; then
    print_warning "GitHub Actions workflow not found - automatic deployment will not work"
    warnings=$((warnings + 1))
else
    print_success "GitHub Actions workflow exists"
fi

# Check for common LaTeX dependencies
print_status "Checking LaTeX compilation environment..."

if command -v pdflatex >/dev/null 2>&1; then
    print_success "pdflatex is available"
    
    # Try a quick compilation test if there are tex files
    if [ -f "resume/*.tex" ]; then
        print_status "Testing LaTeX compilation..."
        cd resume
        
        test_compiled=false
        for tex_file in *.tex; do
            if [ -f "$tex_file" ]; then
                print_status "Testing compilation of $tex_file..."
                if timeout 30 pdflatex -interaction=nonstopmode "$tex_file" > /dev/null 2>&1; then
                    print_success "✓ $tex_file compiles successfully"
                    test_compiled=true
                    break
                else
                    print_warning "✗ $tex_file failed to compile (this may be due to missing packages)"
                fi
            fi
        done
        
        if [ "$test_compiled" = false ]; then
            print_warning "No LaTeX files could be compiled successfully"
            warnings=$((warnings + 1))
        fi
        
        cd ..
    fi
else
    print_warning "pdflatex not found - LaTeX compilation will fail"
    print_status "To install LaTeX:"
    print_status "  Ubuntu/Debian: sudo apt-get install texlive-latex-extra"
    print_status "  macOS: brew install mactex"
    warnings=$((warnings + 1))
fi

# Summary
echo ""
echo "📊 Validation Summary"
echo "===================="

if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    print_success "✅ All checks passed! Your configuration looks good."
elif [ $errors -eq 0 ]; then
    print_warning "⚠️  Configuration is valid but has $warnings warning(s)"
    echo "   Your site should work but consider addressing the warnings above."
else
    print_error "❌ Found $errors error(s) and $warnings warning(s)"
    echo "   Please fix the errors before deploying."
    exit 1
fi

echo ""
print_status "Next steps:"
print_status "  1. Run './scripts/build.sh build' to test locally"
print_status "  2. Run './scripts/build.sh serve' to preview the site"
print_status "  3. Commit and push to deploy to GitHub Pages"
