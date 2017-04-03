FlowRouter.route '/course/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_course'

if Meteor.isClient
    Template.edit_course.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    Template.edit_course.helpers
        course: -> Docs.findOne FlowRouter.getParam('doc_id')
         
            
    Template.edit_course.events
        'click #save': ->
            FlowRouter.go "/course/view/#{@_id}"
    
                
        'click #delete': ->
            swal {
                title: 'Delete?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                course = Courses.findOne FlowRouter.getParam('doc_id')
                Courses.remove course._id, ->
                    FlowRouter.go "/courses"
    
    