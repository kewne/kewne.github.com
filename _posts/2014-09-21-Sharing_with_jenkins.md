---
layout: blog_post
title: Sharing resources with Jenkins
---
I've recently been asked to design a system for managing the installation of a set of plugins in a server-side third-party application.
The fundamental problem is simple: from a bunch of files in version control, I have to create and copy a bunch of files into a directory.
The source files can potentially be edited by several people at the same time but any version control software should be able to handle it.
It seems like a simple development scenario.

However, due to a lack of proper infrastructure management, it's impossible for a developer to have his own development environment with the application installed: the only development environment must be shared.
Good Continuous Delivery practice also recommends that the deployment method should be the same in all environments in the pipeline:

* Development, which is used for developing and testing new configuration
* Pre-production, which is a stable environment to support development and other pre-production environments for other teams
* Production, which supports production environments

This context poses serious challenges in performing quality delivery:

* Like I mentioned previously, all developers must share the development environment
* Different geographies are involved, making communication harder
* Even in pre-production, there is a low tolerance for failures.
This means that CI has to run against the development instance too, and testing must provide a high level of confidence
* Also mentioned before, the deployment method should be the same

# My solution

(I haven't implemented this yet, I'll update this when I get it working)

The solution I've come up with involves using Jenkins to mediate access to the server, and lock down access to everyone else.
I use a Jenkins job which accepts an archive with the configuration to apply, replaces the configuration on the server, restarts the application and runs the tests.
By changing the concurrency settings in the job, you instantly create a nice queue, which ensures isolation.

Developers can build the configuration archive on their local machine, start a job with it and check the results.
The CI job, on the other hand, can build the job and then start the test job with the build configuration.

In this case, manual testing is not really valuable, so another nice side effect of the method is that validation must be performed by automated tests.

As a downside, you do get some latency if several people are trying to test changes but that's really unavoidable in this situation, and Jenkins runs jobs one after the other so the synchronization overhead is minimal.

# Conclusion

Ideally, you'd always have a throwaway environment which you can use to do development.
In reality, sometimes you need to compromise, and I think the solution I presented is adequate in many situations, which is I decided to share it.
I'm also continually amazed with how Jenkins is incredibly versatile and you can almost always find a simple way to make it work for your use case.
