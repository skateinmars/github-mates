require 'octokit'

class GithubApi
  class << self
    def repository(username, repository)
      Octokit.repo(:username => username, :repo => repository)
    end

    def repository_exists?(username, repository)
      begin
        repository(username, repository)
        return true
      rescue Octokit::NotFound
        return false
      end
    end

    def user(username)
      Octokit.user(username)
    end
  end
end
