#let metadata = toml("./metadata.toml")
#let metadataLocal = toml("./metadata.local.toml")
#let firstName = metadata.personal.first_name
#let lastName = metadata.personal.last_name
#let location = metadataLocal.letter_variables.personal_location
#let regularFont = metadata.layout.fonts.regular_font
#let accentColor = rgb(metadata.layout.accent_color)
#let recipientName = metadataLocal.letter_variables.recipient_name
#let recipientAddress = metadataLocal.letter_variables.recipient_address
#let subject = metadataLocal.letter_variables.letter_subject
#let logo = metadataLocal.letter_variables.recipient_logo
#let homepage = metadata.personal.info.homepage
#let footer = metadata.lang.letter_footer 

#let letterFooter() = {
  let footerStyle(str) = {
    text(size: 8pt, fill: rgb("#999999"), smallcaps(str))
  }

  return place(bottom+left, dy: -15pt, table(
    columns: (1fr, auto),
    inset: 0pt,
    stroke: none,
    footerStyle([#firstName #lastName]), footerStyle(footer),
  ))
}

#let letterHeader() = {
  let letterHeaderNameStyle(str) = {
    text(fill: accentColor, weight: "bold", str)
  }
  let letterHeaderAddressStyle(str) = {
    text(fill: gray, size: 0.9em, smallcaps(str))
  }

  let dynamicLogo(imgPath) = context {
    let img = image("letters/" + imgPath)
    let size = measure(img)
    let ratio = size.width / size.height
    let maxHeight = 25pt
    let imageSize = (height: maxHeight)
    let maxRatio = 3
    if ratio > maxRatio {
      imageSize = (width: maxRatio * maxHeight)
    }
    set image(..imageSize, fit: "contain")
    align(right, img)
  }

  grid(
    columns: (1fr, 1fr),
    grid.cell([
      #letterHeaderNameStyle(firstName + " " + lastName)
      #v(-5pt)
      #letterHeaderAddressStyle(location)
    ]),
    dynamicLogo(logo)
  )

  v(1pt)
  align(right, letterHeaderNameStyle(recipientName))
  v(-5pt)
  align(right, letterHeaderAddressStyle(recipientAddress))
  v(1pt)
  text(size: 0.9em, fill: gray, style: "italic", datetime.today().display())
  v(1pt)
  text(fill: accentColor, weight: "bold", underline(subject))
  v(10pt)
}

#let letterSignature() = {
  text(font: "Caveat", weight: "regular", size: 24pt, "Krystof Spiller")
}

// Page setup
#set page(
  paper: "a4",
  margin: (x: 40pt, y: 30pt),
  footer: letterFooter()
)
// Styling setup
#set text(font: regularFont, weight: "regular", size: 12pt)

#letterHeader()

Dear Hiring Manager,

#{
  show "my homepage": link("https://" + homepage)[#underline("my homepage")]
  let contentPars = metadataLocal.letter_variables.generic_content.split("\n")
  for p in contentPars {
    if p == "" {
      continue
    }
    p
    parbreak()
  }
}

Sincerely,

#letterSignature()