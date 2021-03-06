window.ig.ShareDialog = class ShareDialog
  (@parentElement) ->
    @createShareArea!
    @createShareButton!
    @createShareBackground!
    @parentElement
      ..appendChild @shareBtn
      ..appendChild @shareBackground
      ..appendChild @shareArea
    ig.Events @
    @hash = ""

  createShareArea: ->
    @shareArea = document.createElement \div
      ..id = "shareArea"
      ..className = ''
      ..innerHTML = "Odkaz ke sdílení
      <a href='#' class='close' title='Zavřít'>×</a>
      <input type='text'>
      <a class='social' target='_blank' href='https://www.facebook.com/sharer/sharer.php?u='><img src='https://samizdat.cz/tools/icons/facebook.png' alt='Sdílet na Facebooku' /></a>
      <a class='social' target='_blank' href=''><img src='https://samizdat.cz/tools/icons/twitter.png' alt='Sdílet na Twitteru' /></a>
      <div class='embed'></div>
      "
    @shareArea.querySelector "a.close" .onclick = @~hideShareDialog

  createShareBackground: ->
    @shareBackground = document.createElement \div
      ..id = 'shareBg'
      ..className = ''
      ..onclick = @~hideShareDialog

  createShareButton: ->
    @shareBtn = document.createElement \a
      ..innerHTML = "Sdílet toto místo
        <span class='social' target='_blank' href='https://www.facebook.com/sharer/sharer.php?u='><img src='https://samizdat.cz/tools/icons/facebook.png' alt='Sdílet na Facebooku' /></span>
        <span class='social' target='_blank' href=''><img src='https://samizdat.cz/tools/icons/twitter.png' alt='Sdílet na Twitteru' /></span>"
      ..id = "shareBtn"
      ..onclick = (evt) ~>
        evt.preventDefault!
        @displayShareDialog!
    for let element, index in @shareBtn.querySelectorAll ".social"
      element.onclick = (evt) ~>
        evt.preventDefault!
        evt.stopPropagation!
        link = @getCurrentLink!
        url = if index then link.twitter else link.facebook
        window.open url, "_blank"

  displayShareDialog: ->
    @shareArea.className = @shareBackground.className = "visible"
    link = @getCurrentLink!
    @shareArea.querySelector "input"
      ..value = link.normal
      ..focus!
      ..setSelectionRange 0, link.normal.length
    for elm, index in @shareArea.querySelectorAll ".social"
      elm.href = unless index
         link.facebook
      else
        link.twitter
    embedArea = @shareArea.querySelector "div.embed"
      ..innerHTML = "<a class='embed' href='#'>Zobrazit kód ke vložení do stránky</a>"
      ..onclick = ~>
        text = '<iframe width="1000" height="600" src="' + link.embedded + '" frameborder="0" allowfullscreen></iframe>'
        elm = document.createElement \input
          ..type = 'text'
          ..value = text
          ..focus!
          ..setSelectionRange 0, text.length
        embedArea
          ..innerHTML = ''
          ..appendChild elm
          ..onclick = null

  hideShareDialog: ->
    @shareArea.className = @shareBackground.className = ""

  getCurrentLink: ->
    embedded = document.location.toString!
    referrer = document.referrer || embedded
    referrer = referrer.split '#' .0
    @emit "hashRequested"
    normal = referrer
    normal += '#' + @hash if @hash
    entities = normal.replace '#' '%23'
    facebook = "https://www.facebook.com/sharer/sharer.php?u=" + entities
    twitter = "https://twitter.com/home?status=" + entities + " // @dataRozhlas"
    {normal, entities, facebook, twitter, embedded}

  setHash: (@hash) ->
