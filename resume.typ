#import "@preview/fontawesome:0.2.1": *
#let metadata = toml("./metadata.toml")

#let personalInfo = metadata.personal.info
#let firstName = metadata.personal.first_name
#let lastName = metadata.personal.last_name
#let regularFont = metadata.layout.fonts.regular_font
#let headerFont = metadata.layout.fonts.header_font
#let accentColor = rgb(metadata.layout.accent_color)
#let headerQuote = metadata.lang.header_quote 
#let footer = metadata.lang.resume_footer 
#let regularColors = (
  subtlegray: rgb("#ededee"),
  lightgray: rgb("#343a40"),
  darkgray: rgb("#212529"),
)

// Functions
#let hBar() = [#h(2pt) | #h(2pt)]

#let cvFooter() = {
  // Styles
  let footerStyle(str) = {
    text(size: 8pt, fill: rgb("#999999"), smallcaps(str))
  }

  return place(bottom+left, dy: -30pt, table(
    columns: (1fr, auto),
    inset: 0pt,
    stroke: none,
    footerStyle([#firstName #lastName]), footerStyle(footer),
  ))
}

#let makeLocationInfo() = {
  place(dy: -3pt, dx: 0.9pt, box([#box(move(dy: 1.5pt, fa-location-dot(size: 13pt)))#h(0.9pt) Copenhagen]))
  place(dy: 12pt, box([#box(move(dy: 1.5pt, fa-flag-usa(size: 13pt))) Open to US relocation]))
}

#let makeHeaderInfo() = {
  let iconsArgs = (size: 13pt)
  let personalInfoIcons = (
    phone: fa-mobile-screen-button(..iconsArgs),
    email: fa-envelope(..iconsArgs),
    linkedin: fa-linkedin(..iconsArgs),
    homepage: fa-link(..iconsArgs),
    github: fa-github(..iconsArgs),
    location: fa-location-dot(..iconsArgs),
  )
  let n = 1
  for (k, v) in personalInfo { 
    if v != "" {
      box({
        // Adds icons
        box(move(dy: 1.5pt, personalInfoIcons.at(k)))
        h(5pt)
        // Adds hyperlinks
        if k == "email" {
          link("mailto:" + v)[#v]
        } else if k == "phone" {
          link("tel:" + v)[#v]
        } else if k == "linkedin" {
          link("https://www.linkedin.com/in/" + v)[#v]
        } else if k == "github" {
          link("https://github.com/" + v)[#v]
        } else if k == "homepage" {
          link("https://" + v)[#v]
        } else {
          v
        }
      })
    }
    // Adds hBar
    if n != personalInfo.len() {
      [#h(5pt) #box(height: 15pt, baseline: 25%, line(stroke: 0.9pt, angle: 90deg, length: 100%)) #h(5pt)]
    }
    n = n + 1
  }
}

#let headerNameStyle(str) = {
  text(
    font: headerFont,
    size: 30pt,
    weight: "regular",
    str,
  )
}

#let headerInfoStyle(str) = {
  text(size: 10pt, weight: 600, str)
}

#let headerQuoteStyle(str) = {
  text(size: 14pt, weight: 600, str)
}

#let makeHeaderNameSection() = align(center, table(
    columns: 1fr,
    inset: 0pt,
    stroke: none,
    row-gutter: (5mm, 4mm),
    [#headerNameStyle(firstName) #h(5pt) #headerNameStyle(lastName)],
    // [#grid(columns: (auto, 109pt), gutter: 8pt, [#headerNameStyle(firstName) #h(5pt) #headerNameStyle(lastName)], align(top + left, headerInfoStyle(makeLocationInfo())))],
    [#headerQuoteStyle(headerQuote)],
    [#headerInfoStyle(makeHeaderInfo())],
))

/// Add the title of a section.
/// - title (str): The title of the section.
/// - highlighted (bool): Whether the first n letters will be highlighted in accent color.
/// - letters (int): The number of first letters of the title to highlight.
/// -> content
#let cvSection(
  title,
  highlighted: true,
  letters: 3,
  beforeSectionSkip: 5pt
) = {
  let highlightText = title.slice(0, letters)
  let normalText = title.slice(letters)
  let sectionTitleStyle(str, color: black) = {
    text(size: 14pt, weight: "bold", fill: color, str)
  }

  v(beforeSectionSkip)
  if highlighted {
    sectionTitleStyle(highlightText, color: accentColor)
    sectionTitleStyle(normalText, color: black)
  } else {
    sectionTitleStyle(title, color: black)
  }

  h(2pt)
  box(width: 1fr, line(stroke: 0.9pt, length: 100%))
}

#let dateStyle(str, alignRight: true) = {
  let txt = text(size: 8pt, weight: "medium", fill: gray, style: "oblique", str)
  
  if(alignRight) {
    align(right, txt)
  } else {
    txt
  }
}

#let cvEntry(
  title: "Title",
  society: "Society",
  date: none,
  location: none,
  description: none,
  logo: none,
  interpersonalTags: (),
  techTags: (),
  oneline: false
) = {
  let boldStyle(str) = {
    text(size: 10pt, weight: "bold", str)
  }
  let locationStyle(str) = {
    align(
      right,
      text(weight: "medium", fill: gray, style: "oblique", str),
    )
  }
  let accentStyle(str) = {
    text(size: 8pt, fill: accentColor, weight: "medium", smallcaps(str))
  }
  let entryTagStyle(str) = {
    align(center, text(size: 8pt, weight: "regular", str))
  }
  let entryTagListStyle(tags, interpersonal: false) = {
    for tag in tags {
      box(
        inset: (x: 0.4em),
        outset: (y: 0.4em),
        fill: if (interpersonal) { rgb(metadata.layout.accent_color+ "80") } else { regularColors.subtlegray },
        radius: 3pt,
        entryTagStyle(tag),
      )
      h(5pt)
    }
  }

  let dynamicLogo(img) = context {    
    if (img == none) {
      return
    }
    
    let size = measure(img)
    let ratio = size.width / size.height
    let maxHeight = 20pt
    let imageSize = (height: maxHeight)
    let maxRatio = 3
    if ratio > maxRatio {
      imageSize = (width: maxRatio * maxHeight)
    }
    set image(..imageSize, fit: "contain")
    img
  }

  let content = if (oneline) {
    (
      boldStyle(title),
      dateStyle(date),
    )
  } else {
    (
      boldStyle(society),
      locationStyle(location),
      accentStyle(title),
      dateStyle(date),
    )
  }

  table(
    columns: (auto , 1fr),
    inset: 0pt,
    stroke: none,
    align: horizon,
    column-gutter:if logo == none { 0pt } else { 4pt },
    dynamicLogo(logo),
    table(
      columns: (1fr, auto),
      inset: 0pt,
      stroke: none,
      row-gutter: 6pt,
      align: auto,
      ..content
    ),
  )
  v(-1pt)
  if (description != none) {
    text(description)
    v(0pt)
  }
  entryTagListStyle(interpersonalTags, interpersonal: true)
  entryTagListStyle(techTags)

  v(3pt)
}

#let cvSkill(type: "Type", info: "Info") = {
  let skillTypeStyle(str) = {
    align(horizon + right, text(size: 10pt, weight: "bold", str))
  }
  let skillInfoStyle(str) = {
    text(str)
  }

  table(
    columns: (16%, 1fr),
    inset: 0pt,
    column-gutter: 10pt,
    stroke: none,
    skillTypeStyle(type), skillInfoStyle(info),
  )
  v(-2pt)
}

// Page setup
#set page(
  paper: "a4",
  margin: (x: 30pt, y: 36pt),
  background: place(top+left, rect(height: 100%, width: 100%, fill: gradient.linear(..color.map.flare, angle: 60deg))[
    #place(top+left, dx: 15pt, dy: 15pt, rect(height: 100%-30pt, width: 100%-30pt, fill: white, radius: 10pt))
  ]),
  footer: cvFooter()
)
// Styling setup
#set text(font: regularFont, weight: "regular", size: 9pt)

// Document content
#makeHeaderNameSection()

#cvSection("Professional experience")

#cvEntry(
  title: [Senior Software Engineer],
  society: [Carta],
  logo: image("img/carta.svg"),
  date: [2022 - Present],
  location: [Copenhagen, Denmark],
  description: "I enabled better sales offerring and transparent management of billing for customers by revamping billing in a cross-functional teamwork, increased product demand by creating a tool for fundraising founders, delivered high-impact features despite tight deadlines, implemented in-app workflows increasing revenue for additional paid service by 300%, provided affordable currency exchange rate solution for 200+ currencies, enhanced UX and DX of modal component and improved product reliability by automating link validation and adding data integrity checks. Presented upcoming features to both company-wide and small stakeholder groups, tailoring the presentation accordingly. Collaborated with and on solutions with designers and product managers. Communicated clear and critical feedback in code reviews.",
  interpersonalTags: ("Cross-functional teamwork", "Ideation sessions", "Technical discussions", "Stakeholder demos", "Office hours"),
  techTags: ("HubSpot", "Stripe"),
)

#cvEntry(
  title: [Junior Software Engineer],
  society: [Capdesk (Acquired by Carta)],
  logo: image("img/capdesk.png"),
  date: [2020 - 2022],
  location: [Copenhagen, Denmark],
  description: "I coached a new engineer and a designer, saved time for an engineering lead by automating app release announcements in Slack, improved copy quality through automated grammar and spellchecking using LanguageTool via GitHub Actions and, by adding OpenAPI, laid the foundation for future improvements like automated TypeScript type generation. Spearheaded multiple improvements to internal processes. Demonstrated eagerness to learn and improve from my colleagues and critical feedback from 1:1s and performance reviews.",
  interpersonalTags: ("Mentoring", "Knowledge sharing", "Pair programming"),
  techTags: ("Ruby on Rails", "React", "TypeScript", "PostgreSQL", "GitHub Actions", "Heroku", "Slack API"),
)

#cvEntry(
  title: [Junior Software Engineer],
  society: [Systematic],
  logo: image("img/systematic.png"),
  date: [2019 - 2020],
  location: [Aarhus, Denmark],
  description: "Accelerated developer velocity for hospital task system app for nurses and orderlies by streamlining dependency management and build system. Maintained high software quality by participating in acceptance testing.",
  interpersonalTags: ("Acceptance testing", "Retrospectives", "Daily standup", "Kanban"),
  techTags: ("Powershell", "C#", ".NET Core", "TeamCity", "Grunt"),
)

#cvSection("Education")

#cvEntry(
  title: [Master of Computer Science and Engineering],
  society: [Technical University of Denmark, Copenhagen],
  date: [2020 - 2022],
  location: [Denmark],
  logo: image("img/dtu.png"),
  description: list(
    [_Thesis_: Aiding Informed Critical Thinking: Mining and Visualizing the Evolution of Online Content],
    [_AI and algorithms study line_: Data structures #hBar() Multi-agent systems #hBar() Deep learning #hBar() UX engineering #hBar() Computer vision],
  ),
)

#cvEntry(
  title: [Bachelor of ICT Engineering],
  society: [VIA University College, Horsens],
  date: [2016 - 2020],
  location: [Denmark],
  logo: image("img/via.png"),
  description: list(
    [_Final project_: Cloud computing for end users #hBar() Electron #hBar() React #hBar() Docker],
    [_Data engineering specialization_: Database optimization #hBar() Data security and encryption #hBar() Data warehousing],
  ),
)

#cvSection("Certificates")

#grid(
  columns: (1fr, 1fr),
  rows: auto,
  gutter: 6pt,
  cvEntry(
    title: [Boot.dev #dateStyle("- 2023", alignRight: false)],
    society: [Learn #box(baseline: 17%, image(height: 9pt, "img/go.png")) for Developers],
    logo: image("img/bootdev.png"),
  ),
  cvEntry(
    title: [DeepLearning.AI #dateStyle("- 2020", alignRight: false)],
    society: [Deep Learning Specialization],
    logo: image("img/deep-learning-ai.png"),
  )
)

#cvSection("Projects")

#cvEntry(
  title: [HabitVille],
  date: [2023 - Present],
  description: list(
    [Hobby project for tracking habits and gamifying it in a tycoon-game. Started with a web app, now working on an iOS mobile app.],
  ),
  techTags: ("NextJS", "React Native", "Expo", "iOS", "AWS RDS", "BaaS - AppWrite | Convex", "NativeWind"),
  oneline: true
)

#cvSection("Skills")

#cvSkill(
  type: [Interpersonal],
  info: [Thorough & kind code reviews #hBar() Sharing critical feedback in a non-contentious way],
)

#cvSkill(
  type: [Technologies],
  info: [Ruby on Rails #hBar() React (+ Native) #hBar() TypeScript #hBar() PostgreSQL #hBar() Git #hBar() GitHub Actions #hBar() Tailwind CSS #hBar() Go #hBar() C\# #hBar() Typst],
)

#cvSkill(
  type: [Services],
  info: [Stripe #hBar() HubSpot #hBar() Heroku #hBar() Slack API #hBar() Netlify #hBar() PlanetScale #hBar() Turso],
)