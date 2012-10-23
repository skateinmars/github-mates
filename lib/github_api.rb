require 'octokit'

class GithubApi
  class << self
    def repository(username, repository)
      github_client.repo(:username => username, :repo => repository)
    end

    def repository_exists?(username, repository)
      begin
        repository(username, repository)
        return true
      rescue Octokit::NotFound
        return false
      end
    end

    def repository_commiters(username, repository)
      github_client.contributors(:username => username, :repo => repository)
    end

    # TODO filter the PR while querying the API
    def repository_issues_users(username, repository)
      issues = github_client.issues(:username => username, :repo => repository).select { |issue| issue.pull_request.html_url.nil? }.uniq_by(&:user)
      issues.map {|issue| {:issue => issue.to_hash, :user => Commiter.import_from_github(issue.user.login)} }
    end

    def user(username)
      github_client.user(username)
    end

    def github_client
      if Settings.github && Settings.github.login
        Octokit::Client.new(:login => Settings.github.login, :password => Settings.github.password)
      elsif Settings.github && Settings.github.client_id
        Octokit::Client.new(:client_id => Settings.github.client_id, :client_secret => Settings.github.client_secret)
      else
        Octokit
      end
    end
  end
end
