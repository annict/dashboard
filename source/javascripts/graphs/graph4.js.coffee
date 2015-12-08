class Ann.Graph4
  @draw: (client) ->
    allLikes = new Keen.Query "count",
      eventCollection: "likes"
      timeframe: "this_90_days"
      interval: "daily"
      filters: [
        "property_name": "action"
        "operator": "eq"
        "property_value": "create"
      ]

    pcLikes = new Keen.Query "count",
      eventCollection: "likes"
      timeframe: "this_90_days"
      interval: "daily"
      filters: [{
        "property_name": "action"
        "operator": "eq"
        "property_value": "create"
      }, {
        "property_name": "device"
        "operator": "eq"
        "property_value": "pc"
      }]

    mobileLikes = new Keen.Query "count",
      eventCollection: "likes"
      timeframe: "this_90_days"
      interval: "daily"
      filters: [{
        "property_name": "action"
        "operator": "eq"
        "property_value": "create"
      }, {
        "property_name": "device"
        "operator": "eq"
        "property_value": "mobile"
      }]

    chart = new Keen.Dataviz()
      .el($('.js-graph-4')[0])
      .chartType("linechart")
      .colors(["#9c27b0", "#2196f3", "#f44336"])
      .title("Like回数")
      .width("auto")
      .prepare()

    client.run [allLikes, pcLikes, mobileLikes], (err, res) ->
      return chart.error(err.message) if err

      result1 = res[0].result
      result2 = res[1].result
      result3 = res[2].result
      data = []

      _.forEach result1, (val, i) ->
        data[i] =
          timeframe: val["timeframe"]
          value: [
            { category: "全て", result: val["value"] }
            { category: "PC", result: result2[i]["value"] }
            { category: "モバイル", result: result3[i]["value"] }
          ]
        chart
          .parseRawData(result: data)
          .render()
