Template.subtitle.events
    'blur #subtitle': ->
        subtitle = $('#subtitle').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: subtitle: subtitle
            
            
Template.tags.events
    'keydown #add_tag': (e,t)->
        if e.which is 13
            doc_id = FlowRouter.getParam('doc_id')
            tag = $('#add_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update doc_id,
                    $addToSet: tags: tag
                $('#add_tag').val('')

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: tag
        $('#add_tag').val(tag)



Template.price.events
    'change #price': ->
        doc_id = FlowRouter.getParam('doc_id')
        price = parseInt $('#price').val()

        Docs.update doc_id,
            $set: price: price
            
            
Template.number.events
    'blur #number': (e) ->
        number = parseInt $('#number').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: number: number
    

            
            
            
Template.title.events
    'blur #title': ->
        # alert 'hi'
        title = $('#title').val()
        Docs.update Template.currentData()._id,
            $set: title: title
            
            
Template.link.events
    'blur #link': ->
        link = $('#link').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: link: link
            
            
Template.page_name.events
    'blur #name': ->
        name = $('#name').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: name: name
            
            
Template.type.events
    'blur #type': ->
        type = $('#type').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: type: type
            
            
Template.image.events
    "change input[type='file']": (e) ->
        doc_id = FlowRouter.getParam('doc_id')
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
            doc_id = FlowRouter.getParam('doc_id')
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
                    Docs.update FlowRouter.getParam('doc_id'), 
                        $unset: image_id: 1

                else
                    throw new Meteor.Error "it failed miserably"

    #         console.log Cloudinary
    # 		Cloudinary.delete "37hr", (err,res) ->
    # 		    if err 
    # 		        console.log "Upload Error: #{err}"
    # 		    else
    #     			console.log "Upload Result: #{res}"
    #                 # Docs.update FlowRouter.getParam('doc_id'), 
    #                 #     $unset: image_id: 1

            
Template.location.events
    'change #location': ->
        doc_id = FlowRouter.getParam('doc_id')
        location = $('#location').val()

        Docs.update doc_id,
            $set: location: location

Template.content.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        # snippet = $('#snippet').val()
        # if snippet.length is 0
        #     snippet = $(html).text().substr(0, 300).concat('...')
        doc_id = FlowRouter.getParam('doc_id')

        Docs.update doc_id,
            $set: content: html
                

Template.content.helpers
    getFEContext: ->
        @current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        self = @
        {
            _value: self.current_doc.content
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }