---
layout: default
title: "Resume"
description: "{{ site.data.config.description }}"
---

<div class="container">
    <!-- Header -->
    <header class="header">
        <h1>{{ site.data.config.name }}</h1>
        <div class="subtitle">{{ site.data.config.title }}</div>
        <div class="description">{{ site.data.config.description }}</div>
        <div class="contact-info">
            <a href="tel:{{ site.data.config.contact.phone }}" class="contact-item">
                📞 {{ site.data.config.contact.phone }}
            </a>
            <a href="mailto:{{ site.data.config.contact.email }}" class="contact-item">
                ✉️ {{ site.data.config.contact.email }}
            </a>
            <a href="https://linkedin.com/in/{{ site.data.config.contact.linkedin }}" class="contact-item" target="_blank">
                💼 LinkedIn
            </a>
            <a href="https://github.com/{{ site.data.config.contact.github }}" class="contact-item" target="_blank">
                🐙 GitHub
            </a>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Resume Viewer -->
        <div class="resume-viewer">
            <div class="resume-controls">
                <div class="version-selector">
                    <label for="version-select">Version:</label>
                    <select id="version-select">
                        {% for version in site.data.config.resume.versions %}
                        <option value="{{ version.file }}" {% if version.file == site.data.config.resume.primary_version %}selected{% endif %}>
                            {{ version.name }}
                        </option>
                        {% endfor %}
                    </select>
                </div>
                <a href="{{ site.baseurl }}/{{ site.data.config.resume.primary_version }}.pdf" class="download-btn" id="download-btn" download>
                    📥 Download PDF
                </a>
            </div>
            
            <div id="pdf-container">
                <div class="loading">Loading resume...</div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="sidebar">
            <!-- Available Versions -->
            <div class="card">
                <h3>📋 Available Versions</h3>
                <ul class="version-list">
                    {% for version in site.data.config.resume.versions %}
                    <li>
                        <div class="version-name">{{ version.name }}</div>
                        <div class="version-desc">{{ version.description }}</div>
                        <a href="{{ site.baseurl }}/{{ version.file }}.pdf" download>Download PDF</a>
                    </li>
                    {% endfor %}
                </ul>
            </div>

            <!-- Quick Stats -->
            <div class="card">
                <h3>📊 Quick Info</h3>
                <div class="stats">
                    <div class="stat-item">
                        <div class="stat-number">{{ site.data.config.resume.versions | size }}</div>
                        <div class="stat-label">Versions</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="last-updated">{{ "now" | date: "%Y" }}</div>
                        <div class="stat-label">Last Updated</div>
                    </div>
                </div>
            </div>

            <!-- About -->
            <!-- <div class="card">
                <h3>ℹ️ About</h3>
                <p>This resume is automatically generated from LaTeX source files and deployed using GitHub Pages. The source code is available on GitHub.</p>
                <a href="https://github.com/{{ site.data.config.contact.github }}/resume" class="github-link" target="_blank">
                    🐙 View Source Code
                </a>
            </div> -->
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; {{ "now" | date: "%Y" }} {{ site.data.config.name }}. All rights reserved.</p>
        <p>Built with ❤️ using LaTeX, GitHub Pages, and GitHub Actions</p>
        {% if site.data.config.display.show_last_updated %}
        <p><small>Last updated: <span id="build-date">{{ "now" | date: "%B %d, %Y" }}</span></small></p>
        {% endif %}
    </footer>
</div>

<!-- JavaScript -->
<script>
    // Configuration from Jekyll data
    const config = {
        versions: [
            {% for version in site.data.config.resume.versions %}
            {
                name: "{{ version.name }}",
                file: "{{ version.file }}",
                description: "{{ version.description }}"
            }{% unless forloop.last %},{% endunless %}
            {% endfor %}
        ],
        primaryVersion: "{{ site.data.config.resume.primary_version }}",
        baseurl: "{{ site.baseurl }}"
    };

    // DOM Elements
    const versionSelect = document.getElementById('version-select');
    const downloadBtn = document.getElementById('download-btn');
    const pdfContainer = document.getElementById('pdf-container');

    // Load PDF function
    function loadPDF(filename) {
        const pdfPath = `${config.baseurl}/${filename}.pdf`;
        
        // Show loading
        pdfContainer.innerHTML = '<div class="loading">Loading resume...</div>';
        
        // Update download button
        downloadBtn.href = pdfPath;
        
        // Try to embed PDF
        setTimeout(() => {
            const embed = document.createElement('embed');
            embed.src = pdfPath;
            embed.type = 'application/pdf';
            embed.className = 'pdf-embed';
            embed.title = 'Resume PDF';
            
            // Fallback for browsers that don't support PDF embedding
            embed.onerror = () => {
                pdfContainer.innerHTML = `
                    <div style="padding: 40px; text-align: center;">
                        <h3>📄 PDF Preview</h3>
                        <p>Your browser doesn't support PDF preview.</p>
                        <a href="${pdfPath}" class="download-btn" style="margin-top: 20px;">
                            📥 Download PDF to View
                        </a>
                    </div>
                `;
            };
            
            pdfContainer.innerHTML = '';
            pdfContainer.appendChild(embed);
        }, 100);
    }

    // Version selector change handler
    versionSelect.addEventListener('change', (e) => {
        loadPDF(e.target.value);
    });

    // Initialize with primary version
    document.addEventListener('DOMContentLoaded', () => {
        loadPDF(config.primaryVersion);
        
        // Set last updated date if available
        const buildDate = document.getElementById('build-date');
        if (buildDate && window.BUILD_DATE) {
            buildDate.textContent = window.BUILD_DATE;
        }
    });
</script>
