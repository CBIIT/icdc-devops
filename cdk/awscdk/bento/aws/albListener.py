from aws_cdk import core
from aws_cdk import aws_elasticloadbalancingv2 as elbv2
from aws_cdk import aws_certificatemanager as cfm

class ALBListener:
  def createResources(self, ns):

    # Attach ALB to ECS Service
    be_health_check = elbv2.HealthCheck(interval=core.Duration.seconds(60),
        path="/ping",
        timeout=core.Duration.seconds(5))

    self.bentoALB.add_redirect(
        source_protocol=elbv2.ApplicationProtocol.HTTP,
        source_port=80,
        target_protocol=elbv2.ApplicationProtocol.HTTPS,
        target_port=443)

    bento_cert = cfm.Certificate.from_certificate_arn(self,
        "bento-cert",
        certificate_arn=self.config[ns]['cert_arn'])

    listener = self.bentoALB.add_listener("PublicListener",
        certificates=[
            bento_cert
        ],
        port=443)

    frontendtarget = listener.add_targets("ECS-frontend-Target",
        port=int(self.config[ns]['frontend_container_port']),
        targets=[self.frontendService],
        target_group_name="{}-frontend".format(ns))
    core.Tags.of(frontendtarget).add("Name", "{}-frontend-alb-target".format(ns))

    backendtarget = listener.add_targets("ECS-backend-Target",
        port=int(self.config[ns]['backend_container_port']),
        targets=[self.backendService],
        health_check=be_health_check,
        target_group_name="{}-backend".format(ns))
    core.Tags.of(backendtarget).add("Name", "{}-backend-alb-target".format(ns))

    # Add a fixed error message when browsing an invalid URL
    listener.add_action("ECS-Content-Not-Found",
        action=elbv2.ListenerAction.fixed_response(200,
            message_body="The requested resource is not available"))

    elbv2.ApplicationListenerRule(self, id="alb_frontend_rule",
        path_pattern="/*",
        priority=1,
        listener=listener,
        target_groups=[frontendtarget])

    elbv2.ApplicationListenerRule(self, id="alb_backend_rule",
        path_pattern="/v1/graphql/*",
        priority=2,
        listener=listener,
        target_groups=[backendtarget])