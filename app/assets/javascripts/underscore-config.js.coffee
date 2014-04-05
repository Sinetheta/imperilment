(->
  "use strict"

    # Allow [% %] as the delimiter instead of <% %> to avoid erb conflict
  _.templateSettings =
    interpolate: /\[%\=(.+?)%\]/g
    evaluate: /\[%(.+?)%\]/g
)()
