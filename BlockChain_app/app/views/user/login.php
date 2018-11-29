<?php
use yii\helpers\Html;
use yii\bootstrap\ActiveForm;
?>
<div class="container wrap-form-login">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-login">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-xs-6">
                            <?= Html::a('Login', ['user/login'], ['class' => 'active']) ?>
                        </div>
                        <div class="col-xs-6">
                            <?= Html::a('Register', ['register']) ?>
                        </div>
                    </div>
                    <hr>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-12">
                            <?php $form = ActiveForm::begin(['action' => ['user/login'], 'id' => 'login-form', 'method' => 'POST']); ?>
                                <?= $form->field($model, 'mail_address')->textInput(['class' => 'form-control', 'placeholder' => 'Email', 'autofocus' => true]) ?>
                                <?= $form->field($model, 'password')->passwordInput(['class' => 'form-control', 'placeholder' => 'Password']) ?>
                                <?= $form->field($model, 'rememberMe')->checkbox() ?>
                            <div class="form-group">
                                <div class="row"><div class="col-sm-2 col-sm-offset-5 text-center">
                                <?= Html::submitButton('LOGIN', ['class' => 'btn btn-primary', 'name' => 'login-button']) ?></div></div>
                            </div>

                            <?php ActiveForm::end(); ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
