#!/usr/bin/env python3
"""
Scaffold a new Flutter page following the layered architecture pattern.

Usage:
  python scaffold_page.py <page_name> [output_dir]

Examples:
  python scaffold_page.py settings
  python scaffold_page.py user_profile lib/pages
"""

import os
import sys
import re


def to_pascal_case(snake_str):
    """Convert snake_case to PascalCase."""
    components = snake_str.split("_")
    return "".join(x.title() for x in components)


def to_snake_case(name):
    """Convert PascalCase or camelCase to snake_case."""
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).lower()


def load_template(template_name):
    """Load a template file from the assets directory."""
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    # Navigate to the assets directory (one level up, then into assets)
    assets_dir = os.path.join(script_dir, "..", "assets")
    template_path = os.path.join(assets_dir, template_name)

    try:
        with open(template_path, "r") as f:
            return f.read()
    except FileNotFoundError:
        raise FileNotFoundError(f"Template file not found: {template_path}")


def create_page_files(page_name, output_dir):
    """Create all four files for a new page."""
    # Convert to appropriate cases
    snake_name = to_snake_case(page_name)
    pascal_name = to_pascal_case(snake_name)

    # Create output directory
    page_dir = os.path.join(output_dir, snake_name)
    os.makedirs(page_dir, exist_ok=True)

    # Load templates from assets directory
    page_template = load_template("page_template.dart").replace(
        "{{PageName}}", pascal_name
    )
    dependency_template = load_template("dependency_template.dart").replace(
        "{{PageName}}", pascal_name
    )
    listener_template = load_template("listener_template.dart").replace(
        "{{PageName}}", pascal_name
    )
    view_template = load_template("view_template.dart").replace(
        "{{PageName}}", pascal_name
    )

    # Write files
    files = {
        "page.dart": page_template,
        "_dependency.dart": dependency_template,
        "_listener.dart": listener_template,
        "_view.dart": view_template,
    }

    for filename, content in files.items():
        filepath = os.path.join(page_dir, filename)
        with open(filepath, "w") as f:
            f.write(content)
        print(f"Created: {filepath}")

    print(f"\n✅ Successfully created {pascal_name}Page in {page_dir}")
    print(f"\nNext steps:")
    print(
        f"1. Import the page: import 'package:your_app/{os.path.relpath(page_dir)}/page.dart';"
    )
    print(f"2. Use it: {pascal_name}Page()")


def main():
    if len(sys.argv) < 2:
        print("Usage: python scaffold_page.py <page_name> [output_dir]")
        print("\nExamples:")
        print("  python scaffold_page.py settings")
        print("  python scaffold_page.py user_profile lib/pages")
        sys.exit(1)

    page_name = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "."

    try:
        create_page_files(page_name, output_dir)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
