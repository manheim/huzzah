module Wikipedia
  class ContentPage < Huzzah::Page

    locator(:first_heading)   { h1(id: 'firstHeading') }

  end
end
