Template.subtitle.events
    'blur #subtitle': ->
        subtitle = $('#subtitle').val()
        Docs.update @_id,
            $set: subtitle: subtitle
            
Template.icon_class.events
    'blur #icon_class': ->
        icon_class = $('#icon_class').val()
        Docs.update @_id,
            $set: icon_class: icon_class
            
Template.created_date.helpers
    created_date: -> 
        console.log @timestamp
        @timestamp

Template.created_date.events
    'blur #created_date': ->
        created_date = $('#created_date').val()
        console.log created_date
        # Docs.update @_id,
        #     $set: created_date: created_date
            
Template.plain.events
    'blur #plain': ->
        plain = $('#plain').val()
        Docs.update @_id,
            $set: plain: plain
            
            
# Template.child_tags.events
#     'keydown #add_tag': (e,t)->
#         if e.which is 13
#             tag = $('#add_tag').val().toLowerCase().trim()
#             if tag.length > 0
#                 Docs.update Template.parentData()._id,
#                     $addToSet: tags: tag
#                 $('#add_tag').val('')

#     'click .doc_tag': (e,t)->
#         tag = @valueOf()
#         Docs.update Template.parentData()._id,
#             $pull: tags: tag
#         $('#add_tag').val(tag)

Template.tags.events
    'keydown #add_tag': (e,t)->
        if e.which is 13
            tag = $('#add_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update Template.currentData()._id,
                    $addToSet: tags: tag
                $('#add_tag').val('')
            

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: tags: tag
        $('#add_tag').val(tag)


Template.location_tags.events
    'keydown #add_location_tag': (e,t)->
        if e.which is 13
            tag = $('#add_location_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update Template.currentData()._id,
                    $addToSet: location_tags: tag
                $('#add_location_tag').val('')
            

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: location_tags: tag
        $('#add_location_tag').val(tag)


Template.intention_tags.events
    'keydown #add_intention_tag': (e,t)->
        if e.which is 13
            tag = $('#add_intention_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update Template.currentData()._id,
                    $addToSet: intention_tags: tag
                $('#add_intention_tag').val('')
            

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: intention_tags: tag
        $('#add_intention_tag').val(tag)



Template.dollar_price.events
    'change #dollar_price': ->
        dollar_price = parseInt $('#dollar_price').val()

        Docs.update @_id,
            $set: dollar_price: dollar_price
            
Template.point_price.events
    'change #point_price': ->
        point_price = parseInt $('#point_price').val()

        Docs.update @_id,
            $set: point_price: point_price
            
            
Template.number.events
    'blur #number': (e) ->
        # console.log @
        val = $(e.currentTarget).closest('#number').val()
        number = parseInt val
        # console.log number
        Docs.update @_id,
            $set: number: number
            
            
Template.title.events
    'blur #title': (e,t)->
        # alert 'hi'
        title = $(e.currentTarget).closest('#title').val()
        Docs.update @_id,
            $set: title: title
            
            
Template.slug.events
    'blur #slug': (e,t)->
        # alert 'hi'
        slug = $(e.currentTarget).closest('#slug').val()
        Docs.update @_id,
            $set: slug: slug
            
            
Template.link.events
    'blur #link': (e,t)->
        link = $(e.currentTarget).closest('#link').val()
        Docs.update @_id,
            $set: link: link
            
            
Template.page_name.events
    'blur #name': (e,t)->
        name = $(e.currentTarget).closest('#name').val()
        Docs.update @_id,
            $set: name: name
            
            
Template.type.events
    'blur #type': (e,t)->
        type = $('#type').val()
        Docs.update @_id,
            $set: type: type
            
Template.template_name.events
    'blur #template_name': (e,t)->
        template_name = $('#template_name').val()
        Docs.update @_id,
            $set: template_name: template_name
            
            
Template.edit_parent_id.events
    'blur #parent_id': (e,t)->
        parent_id = $('#parent_id').val()
        Docs.update @_id,
            $set: parent_id: parent_id
            
            
Template.edit_image.events
    "change input[type='file']": (e) ->
        doc_id = @_id
        files = e.currentTarget.files


        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                # console.log "Upload Error: #{err}"
                # console.dir res
                if err
                    console.error 'Error uploading', err
                else
                    Docs.update doc_id, $set: image_id: res.public_id
                return

    'keydown #input_image_id': (e,t)->
        if e.which is 13
            doc_id = @_id
            image_id = $('#input_image_id').val().toLowerCase().trim()
            if image_id.length > 0
                Docs.update doc_id,
                    $set: image_id: image_id
                $('#input_image_id').val('')



    'click #remove_photo': ->
        swal {
            title: 'Remove Photo?'
            type: 'warning'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Meteor.call "c.delete_by_public_id", @image_id, (err,res) ->
                if not err
                    # Do Stuff with res
                    # console.log res
                    Docs.update @_id, 
                        $unset: 
                            image_id: 1

                else
                    throw new Meteor.Error "it failed miserably"

    'click #remove_image_url': ->
        Docs.update @_id, 
            $unset: 
                image_url: 1
        

    #         console.log Cloudinary
    # 		Cloudinary.delete "37hr", (err,res) ->
    # 		    if err 
    # 		        console.log "Upload Error: #{err}"
    # 		    else
    #     			console.log "Upload Result: #{res}"
    #                 # Docs.update @_id, 
    #                 #     $unset: image_id: 1



    'blur #image_url': ->
        image_url = $('#image_url').val()
        Docs.update @_id,
            $set: image_url: image_url


            
Template.location.events
    'change #location': ->
        doc_id = @_id
        location = $('#location').val()

        Docs.update doc_id,
            $set: location: location

Template.content.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        # snippet = $('#snippet').val()
        # if snippet.length is 0
        #     snippet = $(html).text().substr(0, 300).concat('...')
        doc_id = @_id

        Docs.update doc_id,
            $set: content: html
                

Template.content.helpers
    getFEContext: ->
        @current_doc = Docs.findOne @_id
        self = @
        {
            _value: self.current_doc.content
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                #   'underline'
                #   'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                #   'formatOL'
                #   'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                #   'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                #   'selectAll'
                #   'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                #   'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }


Template.youtube.events
    'blur #youtube': (e,t)->
        youtube = $(e.currentTarget).closest('#youtube').val()
        Docs.update @_id,
            $set: youtube: youtube
            
    'click #clear_youtube': (e,t)->
        $(e.currentTarget).closest('#youtube').val('')
        Docs.update @_id,
            $unset: youtube: 1
            
Template.view_youtube.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000


Template.participants.onCreated ->
    Meteor.subscribe 'usernames'

Template.participants.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update FlowRouter.getParam('doc_id'),
            $addToSet: participant_ids: doc._id
        $('#participant_select').val("")
   
    'click #remove_participant': (e,t)->
        # console.log @
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: participant_ids: @_id



Template.participants.helpers
    participants_edit_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }

    participants: ->
        participants = []
        
        for participant_id in @participant_ids
            participants.push Meteor.users.findOne(participant_id)
        participants

# Template.datetime.onRendered ->
#     Meteor.setTimeout (->
#         $('#datetimepicker').datetimepicker(
#             onChangeDateTime: (dp,$input)->
#                 val = $input.val()

#                 # console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
#                 minute = moment(val).minute()
#                 hour = moment(val).format('h')
#                 date = moment(val).format('Do')
#                 ampm = moment(val).format('a')
#                 weekdaynum = moment(val).isoWeekday()
#                 weekday = moment().isoWeekday(weekdaynum).format('dddd')

#                 month = moment(val).format('MMMM')
#                 year = moment(val).format('YYYY')

#                 datearray = [hour, minute, ampm, weekday, month, date, year]

#                 docid = FlowRouter.getParam 'docId'

#                 doc = Docs.findOne docid
#                 tagsWithoutDate = _.difference(doc.tags, doc.datearray)
#                 tagsWithNew = _.union(tagsWithoutDate, datearray)

#                 Docs.update docid,
#                     $set:
#                         tags: tagsWithNew
#                         datearray: datearray
#                         dateTime: val
#             )), 2000

# Template.location.onRendered ->
#     @autorun ->
#         if GoogleMaps.loaded()
#             $('#place').geocomplete().bind 'geocode:result', (event, result) ->
#                 docid = Session.get 'editing'
#                 Meteor.call 'updatelocation', docid, result, ->

# Template.location.events
#     'click .clearDT': ->
#         tagsWithoutDate = _.difference(@tags, @datearray)
#         Docs.update FlowRouter.getParam('docId'),
#             $set:
#                 tags: tagsWithoutDate
#                 datearray: []
#                 dateTime: null
#         $('#datetimepicker').val('')




#     'click #analyzeBody': ->
#         Docs.update FlowRouter.getParam('docId'),
#             $set: body: $('#body').val()
#         Meteor.call 'analyze', FlowRouter.getParam('docId')

#     'click .docKeyword': ->
#         docId = FlowRouter.getParam('docId')
#         doc = Docs.findOne docId
#         loweredTag = @text.toLowerCase()
#         if @text in doc.tags
#             Docs.update FlowRouter.getParam('docId'), $pull: tags: loweredTag
#         else
#             Docs.update FlowRouter.getParam('docId'), $push: tags: loweredTag

#     docKeywordClass: ->
#         docId = FlowRouter.getParam('docId')
#         doc = Docs.findOne docId
#         if @text.toLowerCase() in doc.tags then 'disabled' else ''


Template.edit_author.onCreated ->
    Meteor.subscribe 'usernames'

Template.edit_author.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        if confirm 'Change author?'
            Docs.update FlowRouter.getParam('doc_id'),
                $set: author_id: doc._id
            $('#author_select').val("")



Template.edit_author.helpers
    author_edit_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }

    # edit_author: ->
    #     participants = []
        
    #     for participant_id in @participant_ids
    #         participants.push Meteor.users.findOne(participant_id)
    #     participants
