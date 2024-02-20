const defaultTheme = require("tailwindcss/defaultTheme");

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["src/layouts/layout.slim", "src/partials/*.{haml,erb}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Roboto\\ Slab", ...defaultTheme.fontFamily.sans],
        mono: ["Space\\ Mono", ...defaultTheme.fontFamily.mono],
      },
      transitionProperty: {
        height: "max-height",
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            maxWidth: "75ch",
            "--tw-prose-code-bg": "rgba(240 240 240 / 80%)",
            "--tw-prose-quotes": theme("colors.gray.600"),
            code: {
              backgroundColor: "var(--tw-prose-code-bg)",
              fontWeight: "inherit",
              letterSpacing: "0.01ch",
              padding: "0.2em 0.4em",
              whiteSpace: "break-spaces",
              borderRadius: "4px",
            },
            "pre code": {
              whiteSpace: "pre",
            },
            a: {
              fontWeight: "inherit",
              color: "var(--tw-prose-body)",
              textUnderlineOffset: "3px",
            },
            "h2, h3": {
              scrollMarginTop: "1rem",
            },
            "h1 a, h2 a, h3 a": {
              textDecoration: "none",
              color: "inherit",
            },
            "h1 a:hover, h2 a:hover, h3 a:hover": {
              textDecoration: "underline",
              textDecorationColor: theme("colors.blue.600"),
              textDecorationThickness: "4px",
              textUnderlineOffset: "4px",
            },
            "a:hover": {
              color: "var(--tw-prose-links)",
            },
            blockquote: {
              fontWeight: theme("fontWeight.normal"),
              fontSize: "1rem",
              letterSpacing: "0.05ch",
              fontStyle: "normal",
            },
            "blockquote p:first-of-type::before": {
              content: "",
            },
            "blockquote p:last-of-type::after": {
              content: "",
            },
            "code::before": {
              content: "",
            },
            "code::after": {
              content: "",
            },
            details: {
              borderWidth: "1px",
              borderColor: theme("colors.gray.300"),
              borderRadius: theme("borderRadius.md"),
              color: "var(--tw-prose-quotes)",
              fontSize: theme("fontSize.small"),
            },
            summary: {
              padding: theme("spacing.4"),
              color: "var(--tw-prose)",
              fontWeight: theme("fontWeight.medium"),
            },
            "summary::marker": {
              color: theme("colors.gray.500"),
            },
            dt: {
              fontWeight: theme("fontWeight.medium"),
            },
            h2: {
              fontWeight: theme("fontWeight.medium"),
            },
            strong: {
              fontWeight: theme("fontWeight.medium"),
            },
            "code strong": {
              fontWeight: theme("fontWeight.semibold"),
              letterSpacing: "0.05ch",
            },
          },
        },
        invert: {
          css: {
            "--tw-prose-code-bg": "rgba(229 229 229 / 10%)",
            "--tw-prose-quotes": theme("colors.gray.300"),
          },
        },
        lg: {
          css: {
            pre: {
              fontSize: "inherit",
            },
            ".lead": {
              lineHeight: "1.6",
            },
          },
        },
      }),
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
