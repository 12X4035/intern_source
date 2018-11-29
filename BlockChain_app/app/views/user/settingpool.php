<?php
use yii\helpers\Html;
use yii\bootstrap\ActiveForm;
use yii\helpers\Url;
?>
<div class="wrapper">
    <?= $this->render('/common/sidebar');?>
    <!-- Page Content Holder -->
    <div id="content">
        <div class="wrap-setting">
            <?php if (!Yii::$app->user->identity->pooladdress) { ?>
                <button type="button" id="createPool" class="btn btn-primary" data-toggle="modal" data-target="#create_pool_popup">
                    <span>Create Pool</span>
                </button><br><br>
            <?php } else { ?>
                <p><strong>Your Address:</strong> <span><?= (Yii::$app->user->identity->pooladdress) ? '0x' . Yii::$app->user->identity->pooladdress : '' ?></span></p>
            <?php } ?>

            <?php $form = ActiveForm::begin(['action' => ['user/settingpool'], 'id' => 'user-form', 'method' => 'POST', 'options' => ['class' => '']]); ?>

                <fieldset><legend>Setting</legend></fieldset>
                <?php if (Yii::$app->session->hasFlash('userFormSubmitted')) { ?>
                        <div class="alert alert-success alert-dismissable">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                            <strong>Well done!</strong> Save successful
                        </div>
                    <?php } ?>
                <?php if (Yii::$app->session->hasFlash('userFormSubmittedError')) { ?>
                        <div class="alert alert-danger alert-dismissable">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                            <strong>Oh snap!</strong> Save data failed
                        </div>
                    <?php } ?>
		<!-- Just change nickname to personaladdress. But...-->
                <?= $form->field($model, 'personaladdress')->textInput(['class' => 'form-control']) ?>
                <div class="form-group clearfix">
                    <div class="col-sm-offset-2 col-sm-10">
                        <div class="pull-right">
                            <?= Html::button('Cancel', ['class' => 'btn btn-default', 'name' => 'back-button', 'onclick' => '(function ( $event ) { window.location.href = "' . Url::to(['post/index']) . '"; })();']) ?>
                            <?= Html::submitButton('Add', ['class' => 'btn btn-primary', 'name' => 'login-button']) ?>
                        </div>
                    </div>
                </div>
            <?php ActiveForm::end(); ?>
        </div>
    </div>
</div>
<div class="modal fade create_pool_popup" id="create_pool_popup">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <a href="#" data-dismiss="modal" class="class pull-right"><span class="glyphicon glyphicon-remove"></span></a>
                <h3>Create Pool</h3>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger alert-dismissable" style="display: none;">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                    <span>Oh snap! Create Pool failed.</span>
                </div>
		<!-- Pool Address -->
		<?php $form = ActiveForm::begin(['action' => ['user/settingpool'], 'id' => 'create-pool-form', 'method' => 'POST']); ?>
		    <?= $form->field($model, 'pooladdress')->textInput(['id' => 'pooladdress', 'class' => 'form-control']) ?>
                    <?= $form->field($model, 'personaladdress')->hiddenInput(['id' => 'personaladdress', 'value' => Yii::$app->user->identity->personaladdress])->label(false); ?>
		
		<div class="field-password">
                    <label class="control-label" for="password">Input password</label>
                    <input type="password" id="accountPassword" class="form-control" name="account-password" value="" placeholder="Password">
                </div>

                <div class="form-group">
                    <div class="row"><div class="col-sm-2 col-sm-offset-5 text-center">
                    <?= Html::button('CREATE', ['id' => 'createPoolBtn', 'class' => 'btn btn-primary btn-lg', 'name' => 'create-pool-button', 'data-loading-text' => '<i class="fa fa-circle-o-notch fa-spin"></i> Creating account...']) ?></div></div>
                </div>

                <?php ActiveForm::end(); ?>	
            </div>
        </div>
    </div>
</div>
