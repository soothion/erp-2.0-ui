'use strict'

angular.module('laravelUiApp')
  .directive('itemView', ($itemView, Meta) ->
    scope:
      "iid": "="
    restrict: 'A'
    link: (scope, element, attrs) ->
      Item = Meta.store('/api/item/info/:id', {id: '@id'})
      Image = Meta.store('/api/item/')

      element.after '<div class="reveal-modal" data-reveal>loading...</div>'
      holder = element.next()[0]

      element.bind 'click', ->
        Item.get {id: scope.iid}, (item) =>
          scope.item = item
          component = React.renderComponent ($itemView {item: scope.item}), holder
        $(holder).foundation 'reveal', 'open'

      $(document).on 'closed.fndtn.reveal', '[data-reveal]', ->
        React.unmountComponentAtNode holder

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder

  )
  .factory '$itemView', ($filter, $label) ->
    {div, h5, dl, dd, a, table, tr, td, th} = React.DOM
    React.createClass
      render: ->
        div {}, [
          h5 {}, 'SKU信息详情'
          table {width: '100%'}, [
            tr {}, [
              th {}, 'SKU'
              td {}, @props.item.sku
              th {}, '产品类型'
              td {}, @props.item.category_id
              th {}, '产品状态'
              td {colSpan: 3}, @props.item.status
            ]
            tr {}, [
              th {}, '描述'
              td {colSpan: 7}, @props.item.description
            ]
            tr {}, [
              th {}, '产品-长(mm)'
              td {}, @props.item.length
              th {}, '产品-宽(mm)'
              td {}, @props.item.width
              th {}, '产品-高(mm)'
              td {}, @props.item.height
              th {}, '产品-重量(g)'
              td {}, @props.item.weight
            ]
            tr {}, [
              th {}, '包装-长(mm)'
              td {}, @props.item.length_package
              th {}, '包装-宽(mm)'
              td {}, @props.item.width_package
              th {}, '包装-高(mm)'
              td {}, @props.item.height_package
              th {}, '包装-重量(g)'
              td {}, @props.item.weight_package
            ]
            tr {}, [
              th {}, '外箱-长(mm)'
              td {}, @props.item.length_carton
              th {}, '外箱-宽(mm)'
              td {}, @props.item.width_carton
              th {}, '外箱-高(mm)'
              td {}, @props.item.height_carton
              th {}, '整箱-重量(kg)'
              td {}, @props.item.weight_carton
            ]
            tr {}, [
              th {}, '装箱数(个)'
              td {}, @props.item.spq
              th {}, '卡板数(个)'
              td {}, @props.item.tray
              th {}, '整箱体积重'
              td {}, @props.item.length_carton * @props.item.width_carton * @props.item.height_carton / 5000
              th {}, ''
              td {}, ''
            ]            
          ]
          table {width: '100%'}, [
            tr {}, [
              th {}, '中文海关描述'
              td {}, @props.item.description_hg_cn
              th {}, '英文海关描述'
              td {}, @props.item.description_hg_en
            ]
            tr {}, [
              th {}, '中国退税率'
              td {}, @props.item.reback_cn
              th {}, '中国海关编码'
              td {}, @props.item.custom_code_cn
            ]
            tr {}, [
              th {}, '美国关税率'
              td {}, @props.item.tariff_us
              th {}, '美国海关编码'
              td {}, @props.item.custom_code_us
            ]
            tr {}, [
              th {}, '欧盟关税率'
              td {}, @props.item.tariff_eu
              th {}, '欧盟海关编码'
              td {}, @props.item.custom_code_eu
            ]
            tr {}, [
              th {}, '英国关税率'
              td {}, @props.item.tariff_en
              th {}, '英国海关编码'
              td {}, @props.item.custom_code_uk
            ]
            tr {}, [
              th {}, '日本关税率'
              td {}, @props.item.tariff_jp
              th {}, '日本海关编码'
              td {}, @props.item.custom_code_jp
            ]
            tr {}, [
              th {}, '海关型号'
              td {}, @props.item.hg_type
              th {}, ''
              td {}, ''
            ]
          ]
          table {width: '100%'}, [
            tr {}, [
              th {}, '品牌'
              td {}, @props.item.brand_type
              th {}, '认证'
              td {}, @props.item.brand_auth
            ]
            tr {}, [
              th {}, '说明书'
              td {}, @props.item.brand_instructions
              th {}, '备注'
              td {}, @props.item.brand_remark
            ]
            tr {}, [
              th {}, '品牌其他信息'
              td {}, ''
              th {}, '其他信息'
              td {}, ''
            ]
          ]
        ]
