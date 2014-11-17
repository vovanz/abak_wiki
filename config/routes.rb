AbakWiki::Application.routes.draw do
  root to: 'wiki#tree'

  match '/add' => 'wiki#add', :defaults => {:parent_url => ''}

  match ':parent_url/add' => 'wiki#add', :constraints => {:parent_url => /.*/}
  match ':url/edit' => 'wiki#edit', :constraints => {:url => /.*/}
  match ':url' => 'wiki#view', :constraints => {:url => /.*/}
end
