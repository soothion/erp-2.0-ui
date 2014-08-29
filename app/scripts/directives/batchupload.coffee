'use strict'

angular.module('laravelUiApp')
  .directive('batchUpload', ($upload, Meta) ->
    restrict: 'E'
    templateUrl: 'directive/batch-upload.html'
    transclude: true
    scope: {
      "label": '@'
      "action": '@'
      "title": '@'
      "template": '@'
      "callback": '=?'
      "params": '=?'
    }
    link: (scope, element, attrs) ->
      open = ->
        $('form[name=batch-upload-form]')[0].reset()
        $('#mainModal').foundation 'reveal', 'open'
        load()

      load = ->
        Meta.store('/api/batch/logs').query {action: scope.action}, (rtn) ->
          scope.logs = rtn

      scope.showlog = (errors) ->
        # FIXME: 不应该用ID索引，如两个以上时ID会冲突
        $('#errorModal').foundation 'reveal', 'open'
        scope.errorHolder = errors

      scope.save = ($files) -> 
        $upload.upload({
          url: "/api/batch/upload/#{scope.action}"
          file: $files[0]
          data: scope.params
        }).progress (evt) ->
          scope.percent = parseInt(100.0 * evt.loaded / evt.total)
        .success ->
          load()

      element.bind 'click', open
      $(document).on 'closed.fndtn.reveal', '[data-reveal]', ->
        scope.callback() if angular.isFunction scope.callback
  )
  .run ($templateCache) ->
    $templateCache.put 'directive/batch-upload.html', "

    <button class=\"button tiny success\">{{label}}</button>

    <div id=\"errorModal\" class=\"reveal-modal\" data-reveal>
      <h5>错误日志.</h5>
      <table width=\"100%\">
        <thead>
          <tr>
            <th>Line</th>
            <th>content</th>
            <th>desc</th>
          </tr>
        </thead>
        <tbody>
          <tr ng-repeat=\"error in errorHolder\">
            <td>{{error.line}}</td>
            <td>{{error.content}}</td>
            <td>{{error.desc}}</td>
          </tr>
        </tbody>
      </table>
      <a class=\"close-reveal-modal\">&#215;</a>
    </div>

    <div id=\"mainModal\" class=\"reveal-modal\" data-reveal>
      <h5>{{title}}</h5>
      <fieldset>
        <legend>请选择文件上传</legend>
        <div class=\"row\">
          <div class=\"columns medium-4\">
            <form name=\"batch-upload-form\">
            <input type=\"file\" name=\"file\" ng-file-select=\"save($files)\" />
            </form>
          </div>
          <div class=\"columns medium-4\">
            <a href=\"/api/batch/template/{{action}}\" target=\"_blank\"><span class=\"label radius success\"><i class=\"fi-download\"></i> 模板下载</span></a>
          </div>
        </div>
      </fieldset>

      <table width=\"100%\" ng-show=\"logs\">
        <thead>
          <tr>
            <th>ID</th>
            <th>上传时间</th>
            <th>上传者</th>
            <th>文件名</th>
            <th>总数据</th>
            <th>处理中</th>
            <th>已完成</th>
            <th>已拒绝</th>
            <th>错误</th>
          </tr>
        </thead>
        <tbody>
          <tr ng-repeat=\"log in logs\">
            <td>{{log.id}}</td>
            <td>{{log.created_at}}</td>
            <td>{{log.agent | agent}}</td>
            <td>{{log.filename}}</td>
            <td>{{log.total}}</td>
            <td>{{log.pending}}</td>
            <td>{{log.approved}}</td>
            <td><a ng-click=\"showlog(log.errors)\">{{log.reject}}</a></td>
            <td>{{log.error}}</td>
          </tr>
        </tbody>
      </table>
      <a class=\"close-reveal-modal\" ng-click=\"cancel()\">&#215;</a>
    </div>
    "
