#!/bin/bash

# Local Resume Build Script
# This script helps you build and test your resume locally

set -e  # Exit on error

echo "🏗️  Local Resume Builder"
echo "========================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -d "resume" ] || [ ! -f "_config.yml" ]; then
    print_error "Please run this script from the repository root directory"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to compile LaTeX files
compile_latex() {
    print_status "Compiling LaTeX files..."
    
    if ! command_exists pdflatex; then
        print_error "pdflatex not found. Please install LaTeX (texlive)"
        print_status "On Ubuntu/Debian: sudo apt-get install texlive-latex-extra"
        print_status "On macOS: brew install mactex"
        return 1
    fi
    
    cd resume
    
    local compiled_count=0
    local total_files=0
    
    for tex_file in *.tex; do
        if [ -f "$tex_file" ]; then
            total_files=$((total_files + 1))
            local base="${tex_file%.tex}"
            
            print_status "Compiling $tex_file..."
            
            # Compile LaTeX (run twice to resolve references)
            if pdflatex -interaction=nonstopmode "$tex_file" > /dev/null 2>&1; then
                pdflatex -interaction=nonstopmode "$tex_file" > /dev/null 2>&1
                print_success "✓ Generated $base.pdf"
                compiled_count=$((compiled_count + 1))
            else
                print_warning "✗ Failed to compile $tex_file"
            fi
        fi
    done
    
    cd ..
    
    if [ $compiled_count -gt 0 ]; then
        print_success "Compiled $compiled_count/$total_files LaTeX files"
        
        # Copy PDFs to root for Jekyll
        cp resume/*.pdf . 2>/dev/null || true
        
        return 0
    else
        print_error "No LaTeX files were successfully compiled"
        return 1
    fi
}

# Function to setup Jekyll
setup_jekyll() {
    print_status "Setting up Jekyll environment..."
    
    if ! command_exists ruby; then
        print_error "Ruby not found. Please install Ruby"
        return 1
    fi
    
    if ! command_exists bundle; then
        print_status "Installing Bundler..."
        gem install bundler
    fi
    
    if [ ! -f "Gemfile.lock" ]; then
        print_status "Installing Jekyll dependencies..."
        bundle install
    fi
    
    print_success "Jekyll environment ready"
    return 0
}

# Function to build Jekyll site
build_jekyll() {
    print_status "Building Jekyll site..."
    
    if bundle exec jekyll build; then
        print_success "Jekyll site built successfully"
        print_status "Site files are in _site/"
        return 0
    else
        print_error "Jekyll build failed"
        return 1
    fi
}

# Function to serve Jekyll site locally
serve_jekyll() {
    print_status "Starting local Jekyll server..."
    print_status "Site will be available at: http://localhost:4000"
    print_status "Press Ctrl+C to stop"
    
    bundle exec jekyll serve --livereload
}

# Function to clean build files
clean() {
    print_status "Cleaning build files..."
    
    # Remove Jekyll build files
    rm -rf _site/
    rm -f .jekyll-cache/
    
    # Remove LaTeX auxiliary files
    cd resume
    rm -f *.aux *.log *.fls *.fdb_latexmk *.synctex.gz *.out *.toc
    cd ..
    
    # Remove copied PDFs from root
    for pdf in resume/*.pdf; do
        if [ -f "$pdf" ]; then
            basename_pdf=$(basename "$pdf")
            rm -f "$basename_pdf"
        fi
    done 2>/dev/null || true
    
    print_success "Build files cleaned"
}

# Function to validate configuration
validate_config() {
    print_status "Validating configuration..."
    
    if [ ! -f "_data/config.yml" ]; then
        print_error "Configuration file _data/config.yml not found"
        return 1
    fi
    
    # Check if primary version file exists
    local primary_version=$(grep "primary_version:" _data/config.yml | cut -d'"' -f2)
    if [ -n "$primary_version" ] && [ ! -f "resume/${primary_version}.tex" ]; then
        print_warning "Primary version file resume/${primary_version}.tex not found"
    fi
    
    print_success "Configuration looks good"
    return 0
}

# Main menu
show_menu() {
    echo ""
    echo "Available commands:"
    echo "  build     - Compile LaTeX and build Jekyll site"
    echo "  latex     - Compile LaTeX files only"
    echo "  jekyll    - Build Jekyll site only"
    echo "  serve     - Start local development server"
    echo "  clean     - Clean all build files"
    echo "  validate  - Validate configuration"
    echo "  help      - Show this menu"
    echo ""
}

# Parse command line arguments
case "${1:-help}" in
    "build")
        validate_config
        compile_latex
        setup_jekyll
        build_jekyll
        print_success "Build complete! Run './scripts/build.sh serve' to test locally"
        ;;
    "latex")
        compile_latex
        ;;
    "jekyll")
        setup_jekyll
        build_jekyll
        ;;
    "serve")
        if [ ! -d "_site" ]; then
            print_status "Site not built yet, building first..."
            validate_config
            compile_latex
            setup_jekyll
            build_jekyll
        fi
        serve_jekyll
        ;;
    "clean")
        clean
        ;;
    "validate")
        validate_config
        ;;
    "help"|*)
        show_menu
        ;;
esac
