require 'sinatra/base'
require 'sinatra/respond_with'
require 'llt/diff'

class Api < Sinatra::Base
  register Sinatra::RespondWith

  get '/diff' do
    gold = Array(params[:gold])
    rev  = Array(params[:reviewable])

    diff = LLT::Diff.new
    diff.diff(gold, rev)

    respond_to do |f|
      f.xml { diff.to_xml }
    end
  end

  get '/report' do
    uris = Array(params[:uri])
    reporter = LLT::Diff.new
    reporter.report(*uris)

    respond_to do |f|
      f.xml { reporter.to_xml(:report)}
    end
  end
end
